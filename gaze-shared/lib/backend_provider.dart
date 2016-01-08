

import "dart:async";

import "package:events/events_nomirrors.dart";
import "package:logging/logging.dart";

import "package:gaze_shared/helper.dart";
import "package:gaze_shared/messages.dart" as messages;


class BackendProvider extends Object with Events {

  static Logger logger = new Logger("gaze");

  dynamic webSocket;
  StreamSubscription _sub;
  Function _restart;

  BackendProvider(this._restart);

  BackendProvider.start(this._restart) {
    _restart();
  }

  String _lastBgImage;

  Stream<int> get onGazersUpdate => on("update_gazers");
  Stream<String> get onBackgroundUpdate => on("update_background");

  void initConnection(openWebSocket) {
    webSocket = openWebSocket;
    // start listening
    _sub = webSocket.listen(_onMessage,
        onError: _restartWebSocket, onDone: _restartWebSocket);
    // request handshake challenge
    webSocket.add(messages.handshakeRequest());
  }

  void _restartWebSocket([error]) {
    logger.warning("WebSocket closed: $error");
    _sub.cancel();
    webSocket.close();
    logger.info("Reopening WebSocket");
    _restart();
  }

  void _onMessage(message) {
    message = messages.parse(message);
    logger.finer("New message from backend: $message");

    if(message["type"] == "handshake_challenge") {
      String pow = makeChallenge(message["challenge"]);
      webSocket.add(messages.handshakeResponse(pow));
    } else if(message["type"] == "update") {
      if(message.containsKey("nb_gazers")) {
        emit("update_gazers", message["nb_gazers"]);
      }
      if(message.containsKey("bg_image_url")) {
        if(message["bg_image_url"] != _lastBgImage) {
          emit("update_background", message["bg_image_url"]);
          _lastBgImage = message["bg_image_url"];
        }
      }
    }
  }
}