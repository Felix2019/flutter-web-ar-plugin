import 'package:js/js.dart';

@JS('GLTFLoader')
class GLTFLoader {
  external factory GLTFLoader();
  external dynamic load(String url);
}
