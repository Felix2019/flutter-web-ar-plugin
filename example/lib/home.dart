import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/widgets/cube_scene.dart';
import 'package:flutter_web_xr/widgets/three_canvas.dart';
import 'package:flutter_web_xr_example/battery_page.dart';
import 'package:js/js.dart';

@JS()
external void createAlert(String message);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _flutterWebXrPlugin = FlutterWebXr();

  bool startAR = false;

  Future<bool> isWebXrSupported() async {
    try {
      final bool result = await _flutterWebXrPlugin.isWebXrAvailable();
      return result;
    } catch (e) {
      throw Exception('Failed to check web xr availability');
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
                          builder: (context) => BatteryPage(
                              pluginInstance: _flutterWebXrPlugin)));
                },
                icon: const Icon(Icons.battery_charging_full)),
            const SizedBox(width: 20),
            IconButton.filledTonal(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CubeScene()));
                },
                icon: const Icon(Icons.video_collection)),
            const SizedBox(width: 20)
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
                          onPressed: () async {
                            setState(() {
                              startAR = true;
                            });
                          },
                          child: const Text("start ar session")),
                      startAR ? const MyCanvasTest() : const SizedBox(),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('WebXR not supported'),
                );
              }
            }
          },
        ));
  }
}
