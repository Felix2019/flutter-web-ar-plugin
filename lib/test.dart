@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external String get url;

@JS()
external void createAlert(String message);

// This function will do Promise to return something
@JS()
external dynamic jsPromiseFunction(String message);

// This function will open new popup window for given URL.
@JS()
external dynamic jsOpenTabFunction(String url);

@JS('console.log')
external test1(dynamic message);

@JS('JSON.stringify')
external String stringify(Object? obj);

@JS()
@anonymous
class MyObject {
  external num get x;
  external set x(num value);

  external num get y;
  external set y(num value);
}

// @JS('navigator.getBattery')
// external void hallo(void Function(BatteryManager) callback);


