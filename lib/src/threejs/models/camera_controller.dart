import 'dart:html';

import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/utils.dart';

abstract class Camera {
  void initCamera();
}

class CameraController implements Camera {
  late PerspectiveCamera perspectiveCamera;

  CameraController() {
    initCamera();
    domLog("create camera controller");
  }

  @override
  void initCamera() {
    // camera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    // das hat hier funktioniert mit camera z pos = 30 und object pos = -2
    // perspectiveCamera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 10);

    // perspectiveCamera = PerspectiveCamera(
    //     70, window.innerWidth! / window.innerHeight!, 0.01, 10);
    // perspectiveCamera.position.z = 5;

    perspectiveCamera = PerspectiveCamera();
    perspectiveCamera.matrixAutoUpdate = false;

    // camera.position.x = 0;
    // camera.position.y = 2.5;
    // camera.position.z = 30;

    // camera.position. set( 0, 1.6, 3 );

    // scene.add(camera);
    // camera.matrixAutoUpdate = false;
  }
}
