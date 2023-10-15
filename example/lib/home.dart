import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';
import 'package:flutter_web_xr/widgets/three_scene.dart';
import 'package:flutter_web_xr_example/battery_page.dart';
import 'package:flutter_web_xr/widgets/object_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterWebXr _flutterWebXrPlugin = FlutterWebXr();

  late List<ThreeModel> models;

  @override
  void initState() {
    super.initState();
    models = _initializeModels();
  }

  List<ThreeModel> _initializeModels() {
    return [
      // cube model
      ThreeModel(
        name: 'Cube',
        startARSession: () async {
          await startXRSession(
              context, () => _flutterWebXrPlugin.createCube(sideLength: 0.2));
        },
        scene: ThreeScene(
          createdViewId: 'cube',
          object: _flutterWebXrPlugin.createCube(sideLength: 1),
        ),
      ),
      // cone model
      ThreeModel(
          name: 'Cone',
          startARSession: () async {
            await startXRSession(context,
                () => _flutterWebXrPlugin.createCone(radius: 0.2, height: 0.6));
          },
          scene: ThreeScene(
            createdViewId: 'cone',
            object: _flutterWebXrPlugin.createCone(radius: 0.6, height: 0.8),
          )),
      // heart model
      ThreeModel(
          name: 'Heart',
          startARSession: () async {
            await startXRSession(context,
                () => _flutterWebXrPlugin.createHeart(color: 0xff3333));
          },
          scene: ThreeScene(
            createdViewId: 'heart',
            object: _flutterWebXrPlugin.createHeart(color: 0xff3333),
          )),
      // gltf model
      ThreeModel(
          name: 'Shiba',
          startARSession: () async {
            await startXRSession(
                context,
                () async => await _flutterWebXrPlugin
                    .loadGLTFModel('models/shiba/scene.gltf'));
          },
          scene: const ThreeScene(
            createdViewId: 'gltfObject',
            path: 'models/shiba/scene.gltf',
          )),
    ];
  }

  bool isWebXrSupported(BuildContext context) {
    try {
      return _flutterWebXrPlugin.isWebXrAvailable();
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to check web xr availability');
      return false;
    }
  }

  Future<void> startXRSession(
      BuildContext context, Function createObject) async {
    try {
      createObject();
      await _flutterWebXrPlugin.startSession();
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to start web xr session');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Web AR Plugin'),
          scrolledUnderElevation: 0,
          actions: [
            IconButton.filledTonal(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatteryPage(
                              pluginInstance: _flutterWebXrPlugin)));
                },
                icon: const Icon(Icons.battery_charging_full)),
            const SizedBox(width: 15),
            IconButton.filledTonal(
                onPressed: () {
                  _flutterWebXrPlugin.openWindow(
                      'https://github.com/Felix2019/flutter-web-ar-plugin');
                },
                icon: const Icon(Icons.code)),
            const SizedBox(width: 15),
          ],
        ),
        body: isWebXrSupported(context)
            ? ObjectGrid(models: models)
            : const Center(child: Text('WebXR not supported')));
  }
}
