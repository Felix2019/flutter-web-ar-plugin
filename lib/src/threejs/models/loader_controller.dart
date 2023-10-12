import 'dart:async';

import 'package:flutter_web_xr/src/threejs/interop/loaders.dart';
import 'package:js/js.dart';

class LoaderController {
  final GLTFLoader loader = GLTFLoader();

  void initDracoLoader() {
    // final dracoLoader = DRACOLoader();
    // dracoLoader.setDecoderPath('/examples/jsm/libs/draco/');
    // loader.setDRACOLoader(dracoLoader);
  }

  Future<dynamic> loadModel(String path) {
    final Completer<dynamic> completer = Completer<dynamic>();

    loader.load(
      path,
      allowInterop((gltf) {
        completer.complete(gltf.scene);
      }),
      allowInterop((progress) {
        // Optional: progress callback
      }),
      allowInterop((error) {
        completer.completeError(error);
      }),
    );

    return completer.future;
  }
}
