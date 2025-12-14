import 'package:flutter/material.dart';
import '../models/spot.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Spot spot = ModalRoute.of(context)!.settings.arguments as Spot;

    return Scaffold(
      body: Stack(
        children: [
          // Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(spot.imageUrl, fit: BoxFit.cover),
          ),
          // Back Button
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          // Content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(spot.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 4),
                        Text(spot.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text(" (120 Reviews)", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Tentang Tempat Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(spot.description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                    const SizedBox(height: 24),
                    const Text("Fasilitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: spot.facilities.map((f) => _buildFacility(context, f)).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Mulai dari", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Rp ${spot.price.toInt()}",
                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text("/malam", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/booking_form', arguments: spot),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Pesan Sekarang"),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacility(BuildContext context, String name) {
    IconData icon;
    switch (name) {
      case "Tenda": icon = Icons.camping; break;
      case "WiFi": icon = Icons.wifi; break;
      case "Api Unggun": icon = Icons.local_fire_department; break;
      case "Toilet": icon = Icons.wc; break;
      default: icon = Icons.check_circle;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
