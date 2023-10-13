import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/utils/theme.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';

class ObjectContainer extends StatelessWidget {
  final ThreeModel model;

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
          // three model
          model.scene,
          // model name
          Align(
            alignment: Alignment.topCenter,
            child: Chip(
              backgroundColor: CustomTheme.primaryColor,
              side: BorderSide.none,
              elevation: 2,
              label: Text(model.name, maxLines: 1),
            ),
          ),
          // start button
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
