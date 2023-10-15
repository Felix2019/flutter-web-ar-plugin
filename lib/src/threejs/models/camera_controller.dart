import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

/// [Camera] defines the interface for camera-related operations.
abstract class Camera {
  void initCamera(bool matrixAutoUpdate);
}

/// [CameraController] implements the [Camera] interface and
/// provides control over a [PerspectiveCamera] instance.
class CameraController implements Camera {
  final bool matrixAutoUpdate;
  late final PerspectiveCamera perspectiveCamera;

  CameraController({required this.matrixAutoUpdate}) {
    initCamera(matrixAutoUpdate);
  }

  @override
  void initCamera(bool matrixAutoUpdate) {
    perspectiveCamera = PerspectiveCamera();
    perspectiveCamera.matrixAutoUpdate = matrixAutoUpdate;
  }

  void setPosition(double? x, double? y, double? z) {
    // perspectiveCamera.position.setValues(x, y, z);

    perspectiveCamera.position.x = x ?? 0;
    perspectiveCamera.position.y = y ?? 0;
    perspectiveCamera.position.z = z ?? 0;
  }
}
