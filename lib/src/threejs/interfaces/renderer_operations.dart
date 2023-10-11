import 'dart:html' as html;

import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

abstract class RendererOperations {
  void initRenderer(html.CanvasElement canvas);
  void render(Scene scene, PerspectiveCamera camera);
  void animate(Scene scene, PerspectiveCamera camera, Mesh object);
  void setSize(num width, num height);
}
