import 'package:js/js.dart';

@JS('GLTFLoader')
class GLTFLoader {
  external factory GLTFLoader();
  external dynamic load(String url, Function onLoad,
      [Function onProgress, Function onError]);
  external void setDRACOLoader(DRACOLoader dracoLoader);
}

@JS('DRACOLoader')
class DRACOLoader {
  external factory DRACOLoader();
  external void setDecoderPath(String url);
}
