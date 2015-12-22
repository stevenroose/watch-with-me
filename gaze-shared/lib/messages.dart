

import "dart:convert";


parse(String message) => JSON.decode(message);

handshakeRequest() {
  return JSON.encode({
    "type": "handshake_request"
  });
}

handshakeChallenge(String challenge) {
  return JSON.encode({
    "type": "handshake_challenge",
    "challenge": challenge
  });
}

handshakeResponse(String pow) {
  return JSON.encode({
    "type": "handshake_response",
    "pow": pow
  });
}

update({
    int nbGazers,
    String bgImageUrl}) {
  var mess = {
    "type": "update"
  };
  if(nbGazers != null) {
    mess["nb_gazers"] = nbGazers;
  }
  if(bgImageUrl != null) {
    mess["bg_image_url"] = bgImageUrl;
  }
  return JSON.encode(mess);
}