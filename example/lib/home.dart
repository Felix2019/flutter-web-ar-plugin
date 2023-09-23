import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr_example/battery_page.dart';
import 'package:flutter_web_xr_example/threeJs.dart';

class Home extends StatelessWidget {
  final _flutterWebXrPlugin = FlutterWebXr();

  Home({super.key});

  Future<bool> isWebXrSupported() async {
    try {
      final bool result = await _flutterWebXrPlugin.isWebXrAvailable();
      return result;
    } catch (e) {
      throw Exception('Failed to check web xr availability');
    }
  }

  Future<void> startXRSession() async {
    try {
      _flutterWebXrPlugin.createCube();
      await _flutterWebXrPlugin.startSession();
    } catch (e) {
      throw Exception('Failed to start web xr session');
    }
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
                          builder: (context) =>
                              const WebglMaterialsBrowser(fileName: "")));
                },
                icon: const Icon(Icons.battery_charging_full)),
            IconButton.filledTonal(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatteryPage(
                              pluginInstance: _flutterWebXrPlugin)));
                },
                icon: const Icon(Icons.battery_charging_full)),
            const SizedBox(width: 20),
            // IconButton.filledTonal(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const CubeScene()));
            //     },
            //     icon: const Icon(Icons.video_collection)),
            const SizedBox(width: 20),
            const SizedBox(width: 20),
            IconButton.filledTonal(
                onPressed: () {
                  _flutterWebXrPlugin.test();
                },
                icon: const Icon(Icons.video_collection)),
          ],
        ),
        body: FutureBuilder<bool>(
          future: isWebXrSupported(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (snapshot.data == true) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async => await startXRSession(),
                          child: const Text("start ar session")),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('WebXR not supported'));
              }
            }
          },
        ));
  }
}
