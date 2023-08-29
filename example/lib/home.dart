import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_xr/battery_manager.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/test.dart';
import 'package:flutter_web_xr/web_xr_manager.dart';
import 'package:flutter_web_xr/widgets/cube_scene.dart';
import 'package:flutter_web_xr/widgets/three_canvas.dart';
import 'package:flutter_web_xr_example/threeJs.dart';
import 'package:flutter_web_xr/widgets/canvas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = 'Unknown';
  final _flutterWebXrPlugin = FlutterWebXr();

  bool isXrAvailable = false;
  MyBatteryManager? battery;
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
        title: const Text('Plugin example app'),
        backgroundColor: Colors.black,
        actions: [
          // IconButton.filled(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const WebGlCamera(
          //                   fileName: "sal",
          //                 )),
          //       );
          //     },
          //     icon: const Icon(Icons.abc)),
          IconButton.outlined(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CubeScene()),
                );
              },
              icon: const Icon(Icons.label_important))
        ],
      ),
      body: startCamera
          ? const Column(
              children: [Expanded(child: HtmlElementView(viewType: 'video'))])
          : Column(
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
                      try {
                        MyBatteryManager result =
                            await _flutterWebXrPlugin.getBatteryLevel();

                        setState(() => battery = result);
                      } catch (e) {
                        throw Exception(e);
                      }
                    },
                    child: const Text("get battery level")),
                Text(battery?.level.toString() ?? 'no battery'),
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
                      test1("message");
                      // _flutterWebXrPlugin.jsTest();
                      await _flutterWebXrPlugin.getPlatformVersion();
                    },
                    child: const Text("js test")),
                ElevatedButton(
                    onPressed: () => openCamera(),
                    child: const Text("open camera")),
              ],
            ),
    );
  }
}
