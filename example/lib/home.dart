import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr_example/battery_page.dart';
import 'package:flutter_web_xr/widgets/object_selector.dart';
import 'package:flutter_web_xr/widgets/start_button.dart';

class Home extends StatelessWidget {
  final FlutterWebXr _flutterWebXrPlugin = FlutterWebXr();

  Home({super.key});

  bool isWebXrSupported() {
    try {
      return _flutterWebXrPlugin.isWebXrAvailable();
    } catch (e) {
      throw Exception('Failed to check web xr availability');
    }
  }

  Future<void> startXRSession(BuildContext context) async {
    try {
      _flutterWebXrPlugin.createCube(sideLength: 0.2);
      // _flutterWebXrPlugin.createCone(radius: 0.2, height: 0.6);
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
        body: isWebXrSupported()
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: ObjectSelector()),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: StartButton(
                      onPressed: () async => await startXRSession(context),
                    ),
                  ),
                ],
              )
            : const Center(child: Text('WebXR not supported')));
  }
}
