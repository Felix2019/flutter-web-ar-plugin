import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interfaces/renderer_operations.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'dart:html' as html;

import 'package:flutter_web_xr/src/threejs/models/object_controller.dart';

class RendererController implements RendererOperations {
  final html.CanvasElement canvas;

  late WebGLRenderer renderer;
  late Object? _gl;

  Object? get glObject => _gl;

  final ObjectController objectController = ObjectController();

  RendererController({required this.canvas}) {
    initRenderer(canvas);
  }

  @override
  void initRenderer(html.CanvasElement canvas) {
    try {
      _gl = canvas.getContext('webgl', {'xrCompatible': true});
      if (_gl == null) throw Exception('Failed to get WebGL context');

      final Object options = jsify({
        'context': _gl,
        'canvas': canvas,
        'alpha': true,
        'preserveDrawingBuffer': true,
      });

      renderer = WebGLRenderer(options);
      renderer.autoClear = false;
      // renderer.xr.enabled = true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void render(Scene scene, PerspectiveCamera camera) =>
      renderer.render(scene, camera);

  @override
  void animate(Scene scene, PerspectiveCamera camera, dynamic object,
      double xValue, double yValue) {
    render(scene, camera);
    // animate process
    objectController.rotateObject(object, xValue: xValue, yValue: yValue);

    Future.delayed(const Duration(milliseconds: 40), () {
      animate(scene, camera, object, xValue, yValue);
    });
  }

  @override
  void setSize(num width, num height) => renderer.setSize(width, height);
}
