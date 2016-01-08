/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library gazer_set;

import "dart:async";

import "package:events/events.dart";
import "package:logging/logging.dart";
import "package:zengen/zengen.dart";

part "gazer_set.g.dart";


class _GazerSet extends Object with Events {

  @Delegate()
  Set _gazers = new Set();

  Logger _logger;

  _GazerSet(Logger this._logger);

  Stream<int> get onLengthChanged => on("lengthChanged");

  void sendMessage(String message) {
    _logger.fine("Sending message to all gazers: $message");
    _gazers.forEach((ws) => ws.add(message));
  }

  @override
  bool add(value) {
    if(_gazers.add(value)) {
      emit("lengthChanged", _gazers.length);
      return true;
    } else {
      return false;
    }
  }

  @override
  bool remove(value) {
    if(_gazers.remove(value)) {
      emit("lengthChanged", _gazers.length);
      return true;
    } else {
      return false;
    }
  }

}