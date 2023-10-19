import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/utilities.dart';

abstract class ThreeScene {
  void createScene();
  void addElement(Object object);
}

class SceneController implements ThreeScene {
  late Scene scene;
  final List<Object> _objects = [];

  SceneController() {
    createScene(); // Initialize the scene when the controller is created
  }

  // Gets the list of active objects in the scene.
  List<Object> get activeObjects => _objects;

  // Sets the background color of the scene.
  set backgroundColor(Color color) => scene.background = color;

  // Adds an element to the scene.
  @override
  void addElement(Object object) {
    scene.add(object);
    _objects.add(object);
  }

  // Initializes the scene.
  @override
  void createScene() {
    scene = Scene();
  }
}
