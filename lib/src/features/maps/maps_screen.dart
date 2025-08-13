import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operational Map')),
      body: FlutterMap(
        options: MapOptions(initialCenter: const LatLng(18.52, 73.85), initialZoom: 7),
        children: [
          TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a','b','c']),
          MarkerLayer(markers: const [
            Marker(point: LatLng(18.52, 73.85), width: 40, height: 40, child: Icon(Icons.location_on, size: 32)),
          ]),
        ],
      ),
    );
  }
}
