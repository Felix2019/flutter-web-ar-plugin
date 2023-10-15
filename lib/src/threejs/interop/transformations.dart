@JS('THREE')
library transformations;

import 'package:flutter_web_xr/src/threejs/interop/utilities.dart';
import 'package:js/js.dart';

@JS('Vector3')
class Vector3 {
  external factory Vector3(num x, num y, num z);
  external dynamic set(num x, num y, num z);
  external void multiplyScalar(num scalar);

  external set position(Vector3 value);

  external double get x;
  external set x(double value);

  external double get y;
  external set y(double value);

  external double get z;
  external set z(double value);

  external setFromMatrixPosition(Matrix4 xrPosition);
}

extension on Vector3 {
  external int field;
  external int get getSet;
  external set getSet1(int val);
  external int method();
}

@JS()
class Rotation {
  external Rotation(num x, num y, num z);

  external num get x;
  external set x(num value);

  external num get y;
  external set y(num value);

  external num get z;
  external set z(num value);
}

@JS()
class Scale {
  external Scale(num x, num y, num z);

  external num get x;
  external set x(num value);

  external num get y;
  external set y(num value);

  external num get z;
  external set z(num value);
}
