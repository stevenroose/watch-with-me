
import "dart:io";

import "package:args/args.dart";

import "package:gaze_shared/messages.dart" as messages;
import "package:gaze_shared/helper.dart";


const String BACKEND_HOST = "ws://gaze-backend.stevenroose.svc.tutum.io:80/";
const String BACKEND_HOST_DEBUG = "ws://localhost:8080";

main(List<String> args) async {
  var parser = new ArgParser()
    ..addFlag("testing", abbr: "t");
  ArgResults params = parser.parse(args);

  WebSocket webSocket;
  WebSocket.connect(params["testing"] ? BACKEND_HOST_DEBUG : BACKEND_HOST).then((ws) {
    webSocket = ws;
    webSocket.listen((message) {
      print("[${new DateTime.now()}] New message: $message");
      message = messages.parse(message);

      if(message["type"] == "handshake_challenge") {
        String pow = makeChallenge(message["challenge"]);
        webSocket.add(messages.handshakeResponse(pow));
      } else if(message["type"] == "update") {
      }
    });

    // request challenge
    webSocket.add(messages.handshakeRequest());
  });
}