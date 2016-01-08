# Watch With Me

This project contains all code for a proof-of-concept full-stack Dart application 
for both the web and mobile devices (Android and iOS using the Flutter framework).

This is nowhere a production-ready application. Moreover, it uses bleeding edge
technologies so it will probably break at some point.

I initially called it Gaze, so it is still codenamed like that.

The project consists of four packages:

 - gaze-backend: This package contains the server backend for the project. 
 It is deployed as a Docker container on Digital Ocean using Tutum.io.
 
 - gaze-app: This package contains the mobile app.  It is built using 
 [Flutter](https://flutter.io) and should eventually be able to becompiled to both
 Android and iOS. The app is currently only deployed on the 
 [Play Store](https://play.google.com/store/apps/details?id=ch.roose.steven.gaze.app).
 
 - gaze-web: This is the web-app deployed at [watchwithme.rocks]().
 Because I went for bleeding edge, it uses [Angular2](https://angular.io).
 
 - gaze-shared: Here resides all shared code for all packages.
