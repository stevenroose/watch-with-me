// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library gaze_web.app_component;

import "dart:html";

import 'package:angular2/angular2.dart';
import 'package:websockets/browser_websockets.dart';

import "package:gaze_shared/backend_provider.dart";


const String BACKEND_URL = "ws://gaze-backend.stevenroose.svc.tutum.io:80/";


@Component(
  selector: 'gaze-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'])
class AppComponent {

  int nbGazers = 0;
  String imageUrl = "https://i.imgur.com/s3bFsdY.jpg";

  BackendProvider backend = new BackendProvider();

  AppComponent() {
    startConnection();
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
      document.body.style.backgroundImage = "url($newBgUrl)";
    });
  }
}
