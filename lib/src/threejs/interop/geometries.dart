@JS('THREE')
library geometries;

import 'package:js/js.dart';

@JS('BoxGeometry')
class BoxGeometry {
  external BoxGeometry(num width, num height, num depth);
}

@JS('ConeGeometry')
class ConeGeometry {
  external ConeGeometry(num radius, num height, num radialSegments);
}

@JS('ExtrudeGeometry')
class ExtrudeGeometry {
  external ExtrudeGeometry(dynamic shape, Object? extrudeSettings);
}
