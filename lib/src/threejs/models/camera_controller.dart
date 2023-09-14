import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

abstract class Camera {
  void initCamera();
}

class CameraController implements Camera {
  late PerspectiveCamera camera;

  PerspectiveCamera get cameraInstance => camera;

  CameraController() {
    initCamera();
  }

  @override
  void initCamera() {
    // camera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    // camera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 10);

    camera = PerspectiveCamera();
    camera.matrixAutoUpdate = false;

    // camera.position.x = 0;
    // camera.position.y = 2.5;
    // camera.position.z = 30;

    // camera.position. set( 0, 1.6, 3 );

    // scene.add(camera);
    // camera.matrixAutoUpdate = false;
  }
}
