import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

/// [Camera] defines the interface for camera-related operations.
abstract class Camera {
  void initCamera();
}

/// [CameraController] implements the [Camera] interface and
/// provides control over a [PerspectiveCamera] instance.
class CameraController implements Camera {
  late final PerspectiveCamera perspectiveCamera;

  CameraController() {
    initCamera();
  }

  @override
  void initCamera() {
    perspectiveCamera = PerspectiveCamera();
    perspectiveCamera.matrixAutoUpdate = false;

    // perspectiveCamera.position.setValues(x, y, z);
    // perspectiveCamera.lookAt(target);
  }
}
