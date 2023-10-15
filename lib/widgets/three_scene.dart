import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/loader_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

/// `ThreeScene` is a widget that integrates 3D models into a Flutter application using Three.js.
/// It can either display a provided 3D mesh object directly or load a 3D model from a provided path.
class ThreeScene extends StatefulWidget {
  /// A unique ID associated with the view created for displaying the 3D model.
  final String createdViewId;

  /// An optional mesh object to be displayed within the scene.
  final Mesh? object;

  /// An optional path to a 3D model that should be loaded and displayed.
  final String? path;

  /// Constructs an instance of `ThreeScene`.
  const ThreeScene(
      {super.key, required this.createdViewId, this.object, this.path});

  @override
  State<ThreeScene> createState() => _ThreeSceneState();
}

class _ThreeSceneState extends State<ThreeScene> {
  /// HTML canvas element where the 3D scene will be rendered.
  final html.CanvasElement canvas = html.CanvasElement();

  /// Controller responsible for rendering the 3D scene.
  late RendererController rendererController;

  /// Controller for managing the 3D scene.
  final SceneController sceneController = SceneController();

  /// Controller for handling camera-related operations.
  final CameraController cameraController =
      CameraController(matrixAutoUpdate: true);

  /// Controller to assist with loading 3D models.
  final LoaderController loaderController = LoaderController();

  @override
  void initState() {
    super.initState();
    rendererController = RendererController(canvas: canvas);

    _registerCanvas();
    _configureCamera();
    _loadAndAddElementToScene();
  }

  /// Registers the canvas to be used within Flutter's platform view system.
  void _registerCanvas() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(widget.createdViewId, (int viewId) => canvas);
  }

  /// Configures the camera's position within the 3D scene.
  void _configureCamera() {
    cameraController.setPosition(null, null, 6);
  }

  /// If an object is provided, adds it directly to the scene. Otherwise, loads a 3D model from the specified path
  /// and then adds it to the scene.
  Future<void> _loadAndAddElementToScene() async {
    if (widget.object == null && widget.path == null) {
      throw Exception('You can only pass either an object or a path');
    }

    if (widget.object != null) {
      sceneController.addElement(widget.object!);
      _startAnimation(widget.object, 0.04, 0.04);
      return;
    }

    if (widget.path != null) {
      try {
        final model = await loaderController.loadModel(widget.path!);

        sceneController.addElement(model);
        _startAnimation(model, 0, 0.04);
      } catch (error) {
        domLog('Error loading model: $error');
      }
    }
  }

  /// Starts the animation of the object in the scene.
  void _startAnimation(dynamic model, double x, double y) =>
      rendererController.animate(sceneController.scene,
          cameraController.perspectiveCamera, model, x, y);

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.createdViewId);
  }
}
