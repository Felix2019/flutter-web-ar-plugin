import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interfaces/renderer_operations.dart';
import 'package:flutter_web_xr/src/threejs/interop/loaders.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'dart:html' as html;

import 'package:flutter_web_xr/src/threejs/models/mesh_controller.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';

class RendererController implements RendererOperations {
  final html.CanvasElement canvas;

  late WebGLRenderer renderer;
  late Object? _gl;

  Object? get glObject => _gl;

  final MeshController meshController = MeshController();

  RendererController({required this.canvas}) {
    initRenderer(canvas);

    final loader = GLTFLoader();
    domLog(loader);
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
      renderer.xr.enabled = true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void render(Scene scene, PerspectiveCamera camera) =>
      renderer.render(scene, camera);

  @override
  void animate(Scene scene, PerspectiveCamera camera, Mesh object) {
    render(scene, camera);
    // animate process
    meshController.rotateObject(object, xValue: 0.04, yValue: 0.04);

    Future.delayed(const Duration(milliseconds: 40), () {
      animate(scene, camera, object);
    });
  }

  @override
  void setSize(num width, num height) => renderer.setSize(width, height);
}
