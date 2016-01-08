
/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

import 'dart:math';

import "package:crypto/crypto.dart" show SHA256;
import "package:cryptoutils/cryptoutils.dart";
import "package:collection/equality.dart";

String randomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(
    length,
    (index){
    return rand.nextInt(33)+89;
  }
  );

  return new String.fromCharCodes(codeUnits);
}


SHA256 sha256 = new SHA256();

bool validateChallenge(String challenge, String pow) {
  if(pow == null)
    return false;
  var dig = sha256.newInstance()..add(CryptoUtils.hexToBytes(challenge));
  return const ListEquality().equals(dig.close(), CryptoUtils.hexToBytes(pow));
}

String makeChallenge(String challenge) {
  var dig = sha256.newInstance()..add(CryptoUtils.hexToBytes(challenge));
  return CryptoUtils.bytesToHex(dig.close());
}