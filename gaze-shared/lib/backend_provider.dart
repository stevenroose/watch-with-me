

import "dart:async";

import "package:events/events_nomirrors.dart";

import "package:gaze_shared/helper.dart";
import "package:gaze_shared/messages.dart" as messages;


class BackendProvider extends Object with Events {


  dynamic webSocket;

  BackendProvider() {

  }

  Stream<int> get onGazersUpdate => on("update_gazers");
  Stream<String> get onBackgroundUpdate => on("update_background");

  void initConnection(openWebSocket) {
    webSocket = openWebSocket;
    // start listening
    webSocket.listen(_onMessage);
    // request handshake challenge
    webSocket.add(messages.handshakeRequest());
  }

  void _onMessage(message) {
    message = messages.parse(message);

    if(message["type"] == "handshake_challenge") {
      String pow = makeChallenge(message["challenge"]);
      webSocket.add(messages.handshakeResponse(pow));
    } else if(message["type"] == "update") {
      if(message.containsKey("nb_gazers")) {
        emit("update_gazers", message["nb_gazers"]);
      }
      if(message.containsKey("bg_image_url")) {
        emit("update_background", message["bg_image_url"]);
      }
    }
  }
}