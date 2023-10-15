import 'dart:html' as html;

import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

abstract class RendererOperations {
  void initRenderer(html.CanvasElement canvas);
  void render(Scene scene, PerspectiveCamera camera);
  void animate(Scene scene, PerspectiveCamera camera, dynamic object,
      double xValue, double yValue);
  void setSize(num width, num height);
}
