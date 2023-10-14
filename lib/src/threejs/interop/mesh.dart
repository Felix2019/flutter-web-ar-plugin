@JS('THREE')
library mesh;

import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:js/js.dart';

@JS('MeshBasicMaterial')
class MeshBasicMaterial {
  external MeshBasicMaterial(Object object);
}

@JS('Mesh')
class Mesh {
  external Mesh(dynamic geometry, List<MeshBasicMaterial> material);
  external Rotation get rotation;
  external Scale get scale;
  external Vector3 get position;
  external set position(Vector3 value);
}

@JS('Shape')
class Shape {
  external Shape();
  external void moveTo(double x, double y);
  external void lineTo(double x, double y);
  external void bezierCurveTo(
      double x1, double y1, double x2, double y2, double x, double y);
}
