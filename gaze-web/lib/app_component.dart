/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library gaze_web.app_component;

import "dart:html";

import 'package:angular2/angular2.dart';
import 'package:websockets/browser_websockets.dart';

import "package:gaze_shared/backend_provider.dart";


const String BACKEND_URL = "ws://gaze-backend.stevenroose.svc.tutum.io:80/";
//const String BACKEND_URL = "ws://localhost:8080/";


@Component(
  selector: 'gaze-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'])
class AppComponent {

  int nbGazers = 0;
  String imageUrl = "https://i.imgur.com/s3bFsdY.jpg";

  BackendProvider backend;

  AppComponent() {
    backend = new BackendProvider.start(startConnection);
    initUpdateListeners();
  }

  void startConnection() {
    BrowserWebSocket.connect(BACKEND_URL).then((ws) {
      backend.initConnection(ws);
    });
  }

  void initUpdateListeners() {
    backend.onGazersUpdate.listen((newNb) {
      nbGazers = newNb;
    });
    backend.onBackgroundUpdate.listen((newBgUrl) {
      // update background
      print("new bg image: $newBgUrl");
      var style = querySelector("html").style;
      style
        ..backgroundImage = "url($newBgUrl)";
//        ..backgroundSize = "cover"
//        ..backgroundRepeat = "no-repeat"
//        ..backgroundPosition = "center center"
//        ..width = "100%"
//        ..height = "100%"
//        ..overflow = "hidden";
//      querySelector("#gaze_main").style.backgroundImage = "url($newBgUrl)";
    });
  }
}
