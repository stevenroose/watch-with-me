

import "dart:async";

import "package:http/http.dart";
import "package:logging/logging.dart";
import "package:reddit/reddit.dart";


const String _REDDIT_APP_ID = "94Fohglo3KikJg";
const String _REDDIT_APP_SECRET = "QFr4lLlvYVRR29lvBH5UWFreu1o";
const String _REDDIT_USERNAME = "gaze-admin";
const String _REDDIT_PASSWORD = "GazerDeGazeGazeGaze";
const String _REDDIT_MULTI_USER = "sroose";
const String _REDDIT_MULTI_NAME = "picporn";


class RedditSource {

  final Logger logger = new Logger("gaze.RedditSource");

  Set<String> _newImages = new Set<String>();
  Set<String> _lastUsedImages = new Set<String>();

  RedditSource();

  Future<Reddit> initReddit() async {
    Reddit reddit = new Reddit(new Client());
    reddit.authSetup(_REDDIT_APP_ID, _REDDIT_APP_SECRET);
    await reddit.authFinish(username: _REDDIT_USERNAME, password: _REDDIT_PASSWORD);
    logger.fine("Reddit auth successful");
    return reddit;
  }

  Future retrieveNewImages([int minAmount = 20]) async {
    Completer finished = new Completer();
    logger.fine("Retrieving new images from Reddit");
    (await initReddit()).multi(_REDDIT_MULTI_USER, _REDDIT_MULTI_NAME).hot().listen((ListingResult listingResult) {
      listingResult.data.children.forEach((listingElement) {
        if(listingElement.data["post_hint"] == "image") {
          if(!_lastUsedImages.contains(listingElement.data.url)) {
            _newImages.add(listingElement.data.url);
          }
        }
      });
      if(_newImages.length < minAmount) {
        logger.fine("Fetching more images");
        listingResult.fetchMore();
      } else {
        finished.complete();
      }
    });
    return finished.future;
  }

  Future<String> getNextImage() async {
    if(_newImages.isEmpty)
      await retrieveNewImages();
    String next = _newImages.first;
    _newImages.remove(next);
    _lastUsedImages.add(next);
    return next;
  }
}



// for testing
main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(print);
  RedditSource s = new RedditSource();

  s.getNextImage().then(print);
}

