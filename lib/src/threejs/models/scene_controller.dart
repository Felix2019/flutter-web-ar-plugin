import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/utilities.dart';
import 'package:flutter_web_xr/utils.dart';

abstract class ThreeScene {
  void createScene();
  void addElement(Object object);
}

class SceneController implements ThreeScene {
  late Scene scene;
  final List<Object> _objects = [];

  List<Object> get activeObjects => _objects;

  set backgroundColor(Color color) => scene.background = color;

  SceneController() {
    domLog("create scene controller");
  }

  @override
  void addElement(Object object) {
    scene.add(object);
    _objects.add(object);
  }

  @override
  void createScene() {
    scene = Scene();
  }
}
