import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr_web.dart';
import 'package:flutter_web_xr/src/utils/colors.dart';

class StartButton extends StatefulWidget {
  const StartButton({super.key});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () async {
          FlutterWebXrWeb().createCone(radius: 0.2, height: 0.6);
          // FlutterWebXrWeb().createCube(sideLength: 0.2);
          await FlutterWebXrWeb().startSession();
        },
        backgroundColor: Palette.accentColor,
        elevation: 1,
        icon: const Icon(Icons.start, color: Colors.white),
        label: const Text(
          "Start AR Session",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }
}
