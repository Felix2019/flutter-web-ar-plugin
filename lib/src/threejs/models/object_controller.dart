import 'package:flutter_web_xr/src/threejs/interfaces/object_operations.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';

class ObjectController implements ObjectOperations {
  @override
  void rotateObject(Mesh object,
      {double xValue = 0, double yValue = 0, double zValue = 0}) {
    object.rotation.x += xValue;
    object.rotation.y += yValue;
    object.rotation.z += zValue;
  }

  @override
  void scaleObject(Mesh object,
      {double xValue = 0, double yValue = 0, double zValue = 0}) {
    object.scale.x += xValue;
    object.scale.y += yValue;
    object.scale.z += zValue;
  }
}
