@JS()
library battery_manager;

import 'package:js/js.dart';

@JS('BatteryManager')
@staticInterop
class BatteryManager {}

extension on BatteryManager {
  external bool get charging;
  external double get level;
}

@JS('navigator.getBattery')
@staticInterop
external BatteryManager getBattery();

@JS()
// @staticInterop
class Test {
  external factory Test(String name);
}

// extension on StaticInterop {
//   external int field;
//   external int get getSet;
//   external set getSet1(int val);
//   external int method();
// }

// void main() {
//   var jsObj = StaticInterop("test");
//   jsObj.field = 1;
//   jsObj.getSet1 = 2;
//   var a = jsObj.getSet;
//   jsObj.method();
// }
