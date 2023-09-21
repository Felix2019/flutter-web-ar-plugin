import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/utilities.dart';
import 'package:flutter_web_xr/utils.dart';

abstract class ThreeScene {
  void addElement(Mesh object);
}

class SceneController implements ThreeScene {
  final Scene scene = Scene();
  final List<Mesh> _objects = [];

  List<Mesh> get activeObjects => _objects;

  set backgroundColor(Color color) => scene.background = color;

  SceneController() {
    domLog("create scene controller");
  }

  @override
  void addElement(Mesh object) {
    scene.add(object);
    _objects.add(object);
  }
}
