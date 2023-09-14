import 'dart:js_util';
import 'package:js/js.dart';

Map<String, dynamic> objectToMap(jsObject) {
  var map = <String, dynamic>{};
  // var propertyNames = js.context.Object.keys(jsObject);
  // var propertyNames = js.JsObject.getOwnPropertyNames(jsObject);
  // print(propertyNames);

  jsObject.forEach((key, value) {
    print(key);
    // map[key] = getProperty(jsObject, key);
    // print(map[key]);
  });

  //  WebBluetoothDevice.fromJSObject(this._jsObject) {
  if (!hasProperty(jsObject, "id")) {
    throw UnsupportedError("JSObject does not have an id.");
  }
  // }

  print(map);

  // for (var propertyName in propertyNames) {
  //   var propertyValue = jsObject[propertyName];
  //   map[propertyName] =
  //       js.context.hasProperty(propertyValue, '\$dart_js_closure')
  //           ? js.allowInterop(propertyValue)
  //           : propertyValue;
  // }

  return map;
}

// This function will open new popup window for given URL.
@JS()
external dynamic jsOpenTabFunction(String url);

@JS('console.log')
external void domLog(dynamic message);

@JS('JSON.stringify')
external String stringify(Object? obj);

@JS('WebGL2RenderingContext')
@staticInterop
class WebGL2RenderingContext {}




// @JS()
// @anonymous
// class MyObject {
//   external num get x;
//   external set x(num value);

//   external num get y;
//   external set y(num value);
// }
