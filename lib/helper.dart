import 'dart:js_util';

import 'package:js/js.dart' as js;

class Helper {
  static Map<String, dynamic> objectToMap(jsObject) {
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
}
