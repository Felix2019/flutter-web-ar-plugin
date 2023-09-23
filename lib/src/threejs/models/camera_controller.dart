import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:flutter_web_xr/utils.dart';

abstract class Camera {
  void initCamera();
}

class CameraController implements Camera {
  late PerspectiveCamera perspectiveCamera;

  CameraController() {
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

// every object is initially created at ( 0, 0, 0 )
// move the camera back so we can view the scene
// (0, 0, 10);

    // perspectiveCamera = PerspectiveCamera(
    //     35, window.innerWidth! / window.innerHeight!, 0.1, 100);

    // perspectiveCamera = PerspectiveCamera(
    //     70, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    perspectiveCamera = PerspectiveCamera();

    // perspectiveCamera.position.x = 0;
    // perspectiveCamera.position.y = 0;
    // perspectiveCamera.position.z = 1;

    perspectiveCamera.matrixAutoUpdate = false;
  }
}
