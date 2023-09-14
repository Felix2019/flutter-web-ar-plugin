import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interfaces/renderer_operations.dart';
import 'package:flutter_web_xr/src/threejs/interop/base.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

class RendererController implements RendererOperations {
  late WebGLRenderer renderer;
  late Object? _gl;
  final String _createdViewId = 'canvas';

  Object? get glObject => _gl;

  final html.CanvasElement _canvas = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.backgroundColor = 'blue';

  RendererController._() {
    _registerCanvas();
  }

  factory RendererController.create() {
    final controller = RendererController._();
    controller._initRenderer();
    return controller;
  }

  void _registerCanvas() {
    try {
      // Register div as a view and ensure the div is ready before we try to use it
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry
          .registerViewFactory(_createdViewId, (int viewId) => _canvas);
    } catch (e) {
      throw Exception('Failed to register canvas: $e');
    }
  }

  Future<void> _initRenderer() async {
    try {
      _gl = _canvas.getContext('webgl', {'xrCompatible': true});

      final Object options = jsify({
        'context': _gl,
        'canvas': _canvas,
        'alpha': true,
        'preserveDrawingBuffer': true,
      });

      renderer = WebGLRenderer(options);
      renderer.autoClear = false;
      // renderer.xr.enabled = true;
    } catch (e) {
      throw Exception('Failed to initialize renderer: $e');
    }
  }

  @override
  void render(Scene scene, PerspectiveCamera camera) =>
      renderer.render(scene, camera);

  @override
  void setSize(num width, num height) => renderer.setSize(width, height);
}
