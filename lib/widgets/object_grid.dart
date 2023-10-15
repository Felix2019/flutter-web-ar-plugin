import 'package:flutter/material.dart';
import 'package:flutter_web_xr/widgets/object_container.dart';
import 'package:flutter_web_xr/widgets/three_model.dart';

/// A widget that displays a grid of 3D models.
class ObjectGrid extends StatefulWidget {
  // List of 3D models to be displayed in the grid.
  final List<ThreeModel> models;

  /// Creates an instance of [ObjectGrid].
  const ObjectGrid({super.key, required this.models});

  @override
  State<ObjectGrid> createState() => _ObjectGridState();
}

class _ObjectGridState extends State<ObjectGrid> {
  @override
  Widget build(BuildContext context) {
    // Getting the screen size
    final Size size = MediaQuery.of(context).size;

    // Calculating the height and width for each grid item
    final double itemHeight = size.height / 2.5;
    final double itemWidth = size.width / 2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header Row with an icon and title
          Row(
            children: [
              const Icon(Icons.grid_view),
              const SizedBox(width: 12.5),
              Text("3D-Objects", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          // Grid displaying 3D models
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
