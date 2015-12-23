
import "dart:async";

import "package:args/args.dart";
import "package:logging/logging.dart";
import "package:shelf/shelf.dart" as shelf;
import "package:shelf/shelf_io.dart" as shelf_io;
import "package:shelf_web_socket/shelf_web_socket.dart";

import "package:gaze_shared/helper.dart";
import "package:gaze_shared/messages.dart" as messages;

import "gazer_set.dart";
import "image_updater.dart";


const Duration IMAGE_REFRESH_INTERVAL = const Duration(minutes: 1);
const Duration IMAGE_REFRESH_INTERVAL_DEBUG = const Duration(seconds: 10);

Logger logger;
GazerSet gazers;
ImageUpdater imageUpdater;

void main(List<String> args) {
  var parser = new ArgParser()
    ..addFlag("testing", abbr: "t");
  ArgResults params = parser.parse(args);

  initLogger();

  var port = 8080;

  initGazers();
  initImageUpdater(params["testing"]);

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests(logger: (message, isError) =>
          isError ? logger.warning(message) : logger.fine(message)))
      .addHandler(webSocketHandler(incomingGazer));

  logger.info("Calling serve");
  shelf_io.serve(handler, params["testing"] ? "localhost" : "0.0.0.0", port).then((server) {
    logger.info("Serving at http://${server.address.host}:${server.port}");
  });
}

void initLogger() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen(print);
  logger = new Logger("gaze");
  logger.info("Logger initialized");
}

void initGazers() {
  logger.info("Initializing gazers");
  gazers = new GazerSet(logger);
  // we make sure that max once every 500 ms an update is pushed
  Duration delayTime = const Duration(milliseconds: 500);
  bool delayUpdate = false;
  Timer scheduledUpdate = new Timer(Duration.ZERO, () {});
  gazers.onLengthChanged.listen((nb) {
    logger.finer("Gazer nb changed: $nb");
    if(!scheduledUpdate.isActive) {
      scheduledUpdate = new Timer(delayUpdate ? delayTime : Duration.ZERO, () {
        delayUpdate = true;
        gazers.sendMessage(messages.update(
          nbGazers: nb,
          bgImageUrl: imageUpdater.currentImageUrl));
        new Timer(delayTime, () {
          delayUpdate = false;
        });
      });
    }
  });
}

void initImageUpdater(bool debug) {
  imageUpdater = new ImageUpdater(gazers,
    debug ? IMAGE_REFRESH_INTERVAL_DEBUG : IMAGE_REFRESH_INTERVAL);
}

Timer idleTimeout(webSocket) => new Timer(const Duration(seconds: 3), () {
  webSocket.close();
});

void incomingGazer(webSocket) {
  String challenge;

  Timer timeout = idleTimeout(webSocket);

  webSocket.listen((message) {
    message = messages.parse(message);

    if(message["type"] == "handshake_request") {
      timeout.cancel();
      challenge = randomString(16);
      webSocket.add(messages.handshakeChallenge(challenge));
      timeout = idleTimeout(webSocket);
    } else if(message["type"] == "handshake_response") {
      timeout.cancel();
      if(validateChallenge(challenge, message["pow"])) {
        gazers.add(webSocket);
      } else {
        webSocket.close();
      }
    } else {
      webSocket.close();
    }
  }, onError: (error, stackTrace) {
    logger.warning(error, error, stackTrace);
    gazers.remove(webSocket..close());
  }, onDone: () {
    gazers.remove(webSocket..close());
  });
}