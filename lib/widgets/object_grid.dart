import 'package:flutter/material.dart';
import 'package:flutter_web_xr/widgets/object_container.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';

class ObjectGrid extends StatefulWidget {
  final List<ThreeModel> models;

  const ObjectGrid({super.key, required this.models});

  @override
  State<ObjectGrid> createState() => _ObjectGridState();
}

class _ObjectGridState extends State<ObjectGrid> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double itemHeight = size.height / 2.5;
    final double itemWidth = size.width / 2;

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
              childAspectRatio: (itemWidth / itemHeight),
              children: widget.models.map((model) {
                return ObjectContainer(model: model);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
