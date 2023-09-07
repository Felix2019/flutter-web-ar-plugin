// import 'package:flutter/material.dart';
// import 'dart:html' as html;
// import 'dart:ui_web' as ui_web;

// class VideoPage extends StatefulWidget {
//   const VideoPage({super.key});

//   @override
//   State<VideoPage> createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage> {
//   @override
//   void initState() {
//     super.initState();
//     registerDiv();
//   }

//   void registerDiv() {
//     // Register div as a view and ensure the div is ready before we try to use it
//     // ignore: undefined_prefixed_name
//     ui_web.platformViewRegistry
//         .registerViewFactory('video', (int viewId) => videoElement);
//   }

//   void openCamera() async {
//     try {
//       setState(() {
//         startCamera = true;
//       });
//       final mediaStream = await html.window.navigator.mediaDevices!
//           .getUserMedia({'video': true});

//       videoElement.srcObject = mediaStream;
//       videoElement.style.width =
//           '100%'; // Passe die Größe des Video-Elements an
//       videoElement.style.height = '100%';

//       // await videoElement.play(); // Starte das Video-Streaming
//     } catch (e) {
//       print('Fehler beim Öffnen der Kamera: $e');
//     }
//   }

//   bool startCamera = false;

//   final videoElement = html.VideoElement()
//     ..style.width = '100%'
//     ..style.backgroundColor = 'blue'
//     ..style.height = '100%'
//     ..autoplay = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Your Battery"),
//         ),
//         body: FutureBuilder<String>(
//           future: getBatteryLevel(),
//           builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               final snackBar =
//                   SnackBar(content: Text(snapshot.error.toString()));

//               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               return const SizedBox();
//             } else {
//               return

//                   // startCamera
//                   const Column(children: [
//                 Expanded(child: HtmlElementView(viewType: 'video'))
//               ]);
//             }
//           },
//         ));
//   }
// }
