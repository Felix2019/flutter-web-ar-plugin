import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/utils/colors.dart';

class StartButton extends StatefulWidget {
  final AsyncCallback onPressed;

  const StartButton({super.key, required this.onPressed});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () async => await widget.onPressed(),
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
