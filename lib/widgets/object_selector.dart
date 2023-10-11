import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/threejs/three_utils.dart';
import 'package:flutter_web_xr/src/utils/colors.dart';
import 'package:flutter_web_xr/src/utils/theme.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';
import 'package:flutter_web_xr/widgets/three_scene.dart';

class ObjectSelector extends StatefulWidget {
  const ObjectSelector({super.key});

  @override
  State<ObjectSelector> createState() => _ObjectSelectorState();
}

final List<ThreeJSModel> models = [
  ThreeJSModel(
      name: 'Cube',
      scene: ThreeScene(
        createdViewId: 'cube',
        object: ThreeUtils.createCube(sideLength: 1),
      )),
  ThreeJSModel(
      name: 'Cone',
      scene: ThreeScene(
        createdViewId: 'cone',
        object: ThreeUtils.createCone(radius: 0.6, height: 1),
      )),
  ThreeJSModel(
      name: 'Test',
      path: '/../../assets/models/cube.glb',
      scene: ThreeScene(
        createdViewId: '3',
        object: ThreeUtils.createCone(radius: 0.2, height: 0.6),
      )),
];

class _ObjectSelectorState extends State<ObjectSelector> {
  void _handleSelect(int index) {
    setState(() {
      for (int i = 0; i < models.length; i++) {
        models[i].isSelected = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view),
              const SizedBox(width: 12.5),
              Text("3D-Objects", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: models.map((model) {
                return ObjectContainer(
                    model: model, onSelect: () => _handleSelect);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ObjectContainer extends StatefulWidget {
  final ThreeJSModel model;
  final VoidCallback onSelect;

  const ObjectContainer(
      {super.key, required this.model, required this.onSelect});

  @override
  State<ObjectContainer> createState() => _ObjectContainerState();
}

class _ObjectContainerState extends State<ObjectContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: InkWell(
        onTap: () {
          widget.onSelect();
        },
        borderRadius: CustomTheme.borderRadius,
        child: Ink(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: CustomTheme.shadow,
              borderRadius: CustomTheme.borderRadius),
          child: Stack(
            children: [
              // three model
              widget.model.scene,
              // model name
              Align(
                alignment: Alignment.topCenter,
                child: Chip(
                  label: Text(widget.model.name, maxLines: 1),
                ),
              ),
              // select
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        child: SelectButton(
                            model: widget.model,
                            onSelect: () => print("object"))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  final ThreeJSModel model;
  final VoidCallback onSelect;

  const SelectButton({super.key, required this.model, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onSelect,
        // onPressed: () {
        //   // setState(() => widget.model.isSelected = !widget.model.isSelected);

        //   var currentIndex = models.indexOf(currentModel);

        //   setState(() {
        //     // widget.model.isSelected = !widget.model.isSelected;
        //     for (var element in models) {
        //       // Ensure 'models' is accessible and contains ThreeJSModel objects
        //       if (element.name != widget.model.name) {
        //         element.isSelected = false;
        //       } else {
        //         element.isSelected = true;
        //       }
        //     }
        //   });
        // },
        style: CustomTheme.elevatedButtonTheme.style!.copyWith(
            backgroundColor: MaterialStateProperty.all<Color?>(model.isSelected
                ? Palette.secondaryColor
                : Palette.accentColor)),
        child: Text(
          model.isSelected ? "Selected" : "Select",
          style:
              TextStyle(color: model.isSelected ? Colors.black : Colors.white),
        ));
  }
}
