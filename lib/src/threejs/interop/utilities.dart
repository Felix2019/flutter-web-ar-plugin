@JS('THREE')
library utilities;

import 'package:js/js.dart';

@JS('Object3D')
class Object3D {
  external factory Object3D();
}

@JS()
class Color {
  external Color(dynamic value, [dynamic a, dynamic b, dynamic c]);
}

@JS('Matrix4')
class Matrix4 {
  external Matrix4();
  external Future<void> fromArray(dynamic value);
}
