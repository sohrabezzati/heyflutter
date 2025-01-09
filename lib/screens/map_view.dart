import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatelessWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  const MapSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
    );
  }
}
