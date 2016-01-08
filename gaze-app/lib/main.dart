

import "dart:io";
import "dart:collection";
import 'dart:ui' as ui;

import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:gaze_shared/backend_provider.dart";


const String BACKEND_URL = "ws://gaze-backend.stevenroose.svc.tutum.io:80/";


void main() {
  runApp(new GazeApplication());
}

class GazeApplication extends StatefulComponent {
  GazeState createState() => new GazeState();
}

class GazeState extends State<GazeApplication> {

  static const String DEFAULT_IMAGE_URL = "https://i.imgur.com/s3bFsdY.jpg";

  int nbGazers = -1;
  Queue<ImageResource> imageQueue = new Queue<ImageResource>();

  BackendProvider backend;

  GazeState() {
    backend = new BackendProvider.start(startConnection);
    imageQueue.addFirst(imageCache.load(DEFAULT_IMAGE_URL));
    initUpdateListeners();
  }

  Future startConnection() async {
    var ws = await WebSocket.connect(BACKEND_URL);
    backend.initConnection(ws);
  }

  void initUpdateListeners() {
    backend.onGazersUpdate.listen((newNb) {
      setState(() {
        nbGazers = newNb;
      });
    });
    backend.onBackgroundUpdate.listen((newBgUrl) {
      imageCache.load(newBgUrl).addListener((ui.Image image) {
        setState(() {
          imageQueue.addFirst(imageCache.load(newBgUrl));
          if(imageQueue.length > 3) {
            imageQueue
              .removeLast()
              .first
              .then((image) => image.dispose());
          }
        });
      });
    });
  }

  Widget build(BuildContext context) =>
    new MaterialApp(
      title: "Watch With Me",
      routes: {
        "/": (RouteArguments args) => new GazeMain(nbGazers, imageQueue.first)
      }
    );
}

class GazeMain extends StatelessComponent {

  final int nbGazers;
  final ImageResource image;

  const GazeMain(this.nbGazers, this.image);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        backgroundImage: new BackgroundImage(
          image: image,
          fit: ImageFit.cover,
          alignment: const FractionalOffset(0.5, 0.5))),
      child: new Align(
        alignment: new FractionalOffset(0.9, 0.9),
        widthFactor: 0.0,
        heightFactor: 0.0,
        child: buildCenterPiece()));
  }

  Widget buildCenterPiece() {
    return new Container(
      padding: new EdgeDims.all(20.0),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        backgroundColor: Colors.white,
        border: new Border.all(color: Colors.black, width: 3.0)),
      child: new Text("${nbGazers >= 0 ? nbGazers : 0}",
        style: new TextStyle(color: Colors.black)));
  }
}
