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
  external Position get position;
  external set position(Position value);
}

@JS('BoxGeometry')
class BoxGeometry {
  external BoxGeometry(num width, num height, num depth);
}

@JS('ConeGeometry')
class ConeGeometry {
  external ConeGeometry(num radius, num height, num radialSegments);
}
