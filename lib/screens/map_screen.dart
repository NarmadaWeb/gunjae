import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/bottom_nav.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordinates for Gunung Jae, Lombok (Approximate)
    // 8.6888° S, 116.1822° E (Narmada area)
    final LatLng lombokCenter =
        const LatLng(-8.5833, 116.3333); // Center of Lombok
    final LatLng gunjaeLocation = const LatLng(-8.6888, 116.1822);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: gunjaeLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gunjae_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: gunjaeLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF13ec5b), // Primary Green
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 16),
                  const Text("Peta Lokasi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {},
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (idx) {
            if (idx == 0) Navigator.pushReplacementNamed(context, '/home');
            if (idx == 2) Navigator.pushReplacementNamed(context, '/history');
            if (idx == 3) Navigator.pushReplacementNamed(context, '/profile');
          }),
    );
  }
}
