import 'package:js/js.dart';

class MyBatteryManager {
  bool charging;
  double level;

  MyBatteryManager(this.charging, this.level);
}

@JS('navigator.getBattery')
external getBattery();

// @JS()
// @anonymous
// class MyObject {
//   external num get x;
//   external set x(num value);

//   external num get y;
//   external set y(num value);
// }

// @JS()
// external MyObject myObject();


