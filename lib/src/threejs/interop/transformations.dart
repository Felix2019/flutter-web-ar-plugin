@JS('THREE')
library transformations;

import 'package:js/js.dart';

@JS('Vector3')
class Position {
  external factory Position(num x, num y, num z);

  external set position(Position value);

  external double get x;
  external set x(double value);

  external double get y;
  external set y(double value);

  external double get z;
  external set z(double value);

  external setFromMatrixPosition(dynamic xrPosition);
}

extension on Position {
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
