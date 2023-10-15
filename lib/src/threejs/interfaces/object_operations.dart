import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';

abstract class ObjectOperations {
  void rotateObject(Mesh object,
      {double xValue = 0, double yValue = 0, double zValue = 0});
  void scaleObject(Mesh object,
      {double xValue = 0, double yValue = 0, double zValue = 0});
}
