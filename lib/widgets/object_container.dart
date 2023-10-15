import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/utils/theme.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';

/// `ObjectContainer` is a widget that displays a 3D model within a decorative container.
///
/// The primary purpose of this widget is to present a 3D model along with an associated name
/// and a start button for an AR session.
class ObjectContainer extends StatelessWidget {
  // The 3D model that is to be displayed within this container.
  final ThreeModel model;

  /// Creates an instance of [ObjectContainer].
  const ObjectContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: CustomTheme.shadow,
          borderRadius: CustomTheme.borderRadius),
      child: Stack(
        children: [
          // Displaying the 3D model.
          model.scene,
          // Chip widget displaying the name of the 3D model.
          Align(
            alignment: Alignment.topCenter,
            child: Chip(
              backgroundColor: CustomTheme.primaryColor,
              side: BorderSide.none,
              elevation: 2,
              label: Text(model.name, maxLines: 1),
            ),
          ),
          // Start button for initiating the AR session.
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async => await model.startARSession(),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                CustomTheme.accentColor)),
                        child: const Text(
                          "Start AR",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
