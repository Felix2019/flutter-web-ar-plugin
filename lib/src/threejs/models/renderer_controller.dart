import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interfaces/renderer_operations.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'dart:html' as html;

class RendererController implements RendererOperations {
  late WebGLRenderer renderer;
  late Object? _gl;

  Object? get glObject => _gl;

  final html.CanvasElement _canvas = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%';

  RendererController() {
    _initRenderer();
  }

  void _initRenderer() {
    try {
      _gl = _canvas.getContext('webgl', {'xrCompatible': true});
      if (_gl == null) throw Exception('Failed to get WebGL context');

      final Object options = jsify({
        'context': _gl,
        'canvas': _canvas,
        'alpha': true,
        'preserveDrawingBuffer': true,
      });

      renderer = WebGLRenderer(options);
      renderer.autoClear = false;
      renderer.xr.enabled = true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void render(Scene scene, PerspectiveCamera camera) =>
      renderer.render(scene, camera);

  @override
  void setSize(num width, num height) => renderer.setSize(width, height);
}
