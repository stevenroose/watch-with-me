

/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

import "dart:async";

import "package:logging/logging.dart";

import "package:gaze_shared/messages.dart" as messages;

import "gazer_set.dart";
import "reddit_source.dart";


class ImageUpdater {

  final Logger logger = new Logger("gaze.ImageUpdater");

  GazerSet gazers;
  Duration updateInterval;

  RedditSource _source = new RedditSource();
  Timer _timer;

  String currentImageUrl;

  ImageUpdater(this.gazers, this.updateInterval) {
    logger.info("Initializing periodic image update timer");
    _timer = new Timer.periodic(updateInterval, (Timer timer) async {
      updateImage();
    });
    updateImage();
  }

  void stop() {
    _timer.cancel();
    gazers = null;
    updateInterval = null;
    _source = null;
    _timer = null;
  }

  updateImage() async {
    logger.fine("Updating image url");
    String newUrl = await _source.getNextImage();
    currentImageUrl = newUrl;
    gazers.sendMessage(messages.update(bgImageUrl: currentImageUrl));
  }

  String getCurrentImage() => currentImageUrl;

}