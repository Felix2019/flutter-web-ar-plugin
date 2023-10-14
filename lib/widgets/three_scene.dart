import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/loader_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class ThreeScene extends StatefulWidget {
  final String createdViewId;
  final Mesh? object;
  final String? path;

  const ThreeScene(
      {super.key, required this.createdViewId, this.object, this.path});

  @override
  State<ThreeScene> createState() => _ThreeSceneState();
}

class _ThreeSceneState extends State<ThreeScene> {
  final html.CanvasElement canvas = html.CanvasElement();

  late RendererController rendererController;
  final SceneController sceneController = SceneController();
  final CameraController cameraController =
      CameraController(matrixAutoUpdate: true);
  final LoaderController loaderController = LoaderController();

  @override
  void initState() {
    super.initState();
    rendererController = RendererController(canvas: canvas);

    _registerCanvas();
    _configureCamera();
    _loadAndAddElementToScene();
  }

  /// Registers the canvas element to be used as a platform view.
  void _registerCanvas() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(widget.createdViewId, (int viewId) => canvas);
  }

  /// Sets the camera position.
  void _configureCamera() {
    cameraController.setPosition(null, null, 6);
  }

  /// Loads the model and adds it to the scene.
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
