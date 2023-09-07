import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';

class BatteryPage extends StatelessWidget {
  final FlutterWebXr pluginInstance;

  const BatteryPage({super.key, required this.pluginInstance});

  String convertResult(double batteryLevel) => "${batteryLevel * 100}%";

  Future<String> getBatteryLevel() async {
    try {
      final double result = await pluginInstance.getBatteryLevel();
      return convertResult(result);
    } catch (e) {
      throw Exception('Failed to fetch battery level');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Battery"),
        ),
        body: FutureBuilder<String>(
          future: getBatteryLevel(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              final snackBar =
                  SnackBar(content: Text(snapshot.error.toString()));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return const SizedBox();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Battery level:",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.data ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 80, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
