import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';

abstract class RendererOperations {
  void _initRenderer();
  void render(Scene scene, PerspectiveCamera camera);
  void setSize(num width, num height);
}
