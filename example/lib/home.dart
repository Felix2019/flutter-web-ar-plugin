import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:flutter_web_xr/widgets/cube_scene.dart';
import 'package:flutter_web_xr/widgets/three_canvas.dart';
import 'package:flutter_web_xr_example/battery_page.dart';
import 'package:flutter_web_xr_example/threeJs.dart';
import 'package:flutter_web_xr/widgets/canvas.dart';
import 'package:js/js.dart';

@JS()
external void createAlert(String message);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = 'Unknown';
  final _flutterWebXrPlugin = FlutterWebXr();

  bool isXrAvailable = false;
  bool startAR = false;

  bool startCamera = false;
  final videoElement = html.VideoElement()
    ..style.width = '100%'
    ..style.backgroundColor = 'blue'
    ..style.height = '100%'
    ..autoplay = true;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    registerDiv();
  }

  Future<String> getBatteryLevel() async {
    try {
      final result = await _flutterWebXrPlugin.isWebXrAvailable();
    } catch (e) {
      throw Exception('Failed to fetch battery level');
    }
  }

  void registerDiv() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry
        .registerViewFactory('video', (int viewId) => videoElement);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterWebXrPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void openCamera() async {
    try {
      setState(() {
        startCamera = true;
      });
      final mediaStream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true});

      videoElement.srcObject = mediaStream;
      videoElement.style.width =
          '100%'; // Passe die Größe des Video-Elements an
      videoElement.style.height = '100%';

      // await videoElement.play(); // Starte das Video-Streaming
    } catch (e) {
      print('Fehler beim Öffnen der Kamera: $e');
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
                    MaterialPageRoute(builder: (context) => const CubeScene()),
                  );
                },
                icon: const Icon(Icons.video_collection)),
            const SizedBox(width: 20)
          ],
        ),
        body: FutureBuilder<String>(
          future: getBatteryLevel(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              final snackBar =
                  SnackBar(content: Text(snapshot.error.toString()));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return const SizedBox();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Running on: $_platformVersion\n'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          bool result =
                              await _flutterWebXrPlugin.isWebXrAvailable();
                          setState(() => isXrAvailable = result);
                        },
                        child: const Text("check web xr api")),
                    Text(isXrAvailable.toString()),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            startAR = true;
                          });
                        },
                        child: const Text("start ar session")),
                    startAR ? const MyCanvasTest() : const SizedBox(),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          // test1("message");
                          // _flutterWebXrPlugin.jsTest();
                          createAlert("message");
                        },
                        child: const Text("js test")),
                    ElevatedButton(
                        onPressed: () => openCamera(),
                        child: const Text("open camera")),
                  ],
                ),
              );
            }
          },
        )

        // startCamera
        //     ? const Column(
        //         children: [Expanded(child: HtmlElementView(viewType: 'video'))])
        //     : Column(
        //         children: [
        //           Center(
        //             child: Text('Running on: $_platformVersion\n'),
        //           ),
        //           ElevatedButton(
        //               onPressed: () async {
        //                 bool result =
        //                     await _flutterWebXrPlugin.isWebXrAvailable();
        //                 setState(() => isXrAvailable = result);
        //               },
        //               child: const Text("check web xr api")),
        //           Text(isXrAvailable.toString()),
        //           ElevatedButton(
        //               onPressed: () async {
        //                 setState(() {
        //                   startAR = true;
        //                 });
        //               },
        //               child: const Text("start ar session")),
        //           startAR ? const MyCanvasTest() : const SizedBox(),
        //           const Spacer(),
        //           ElevatedButton(
        //               onPressed: () async {
        //                 // test1("message");
        //                 // _flutterWebXrPlugin.jsTest();
        //                 createAlert("message");
        //               },
        //               child: const Text("js test")),
        //           ElevatedButton(
        //               onPressed: () => openCamera(),
        //               child: const Text("open camera")),
        //         ],
        //       ),
        );
  }
}
