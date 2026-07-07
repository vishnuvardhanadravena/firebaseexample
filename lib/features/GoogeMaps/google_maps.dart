import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMpasScreen extends StatefulWidget {
  const GoogleMpasScreen({super.key});

  @override
  State<GoogleMpasScreen> createState() => _GoogleMpasScreenState();
}

class _GoogleMpasScreenState extends State<GoogleMpasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps")),
      body: const Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(17.3850, 78.4867),
            zoom: 16,
            tilt: 45,
            bearing: 90,
          ),
        ),
      ),
    );
  }
}