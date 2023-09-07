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
  final _flutterWebXrPlugin = FlutterWebXr();

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
    initPlatformState();
    registerDiv();
  }

  Future<bool> isWebXrSupported() async {
    try {
      final bool result = await _flutterWebXrPlugin.isWebXrAvailable();
      return result;
    } catch (e) {
      throw Exception('Failed to check web xr availability');
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
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      String userAgent = await _flutterWebXrPlugin.getPlatformVersion() ??
          'Unknown platform version';

      // test1(isMobileDevice);
    } on PlatformException {
      throw Exception('Failed to get platform version.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
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
              print(snapshot.data);
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
        )

        // startCamera
        //     ? const Column(
        //         children: [Expanded(child: HtmlElementView(viewType: 'video'))])

        );
  }
}
