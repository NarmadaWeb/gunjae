import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/spot.dart';
import '../models/booking.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Spot spot = args['spot'];
    final Booking booking = args['booking'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Pemesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spot Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(spot.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 12),
                        Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF13ec5b), size: 16),
                            const SizedBox(width: 4),
                            Text(spot.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Detail Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFF13ec5b).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.calendar_month, color: Color(0xFF13ec5b)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tanggal", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text("${DateFormat('dd MMM').format(booking.checkIn)} - ${DateFormat('dd MMM yyyy').format(booking.checkOut)}",
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFF13ec5b).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.group, color: Color(0xFF13ec5b)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tamu", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text("${booking.guests} Orang", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Rincian Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Rp ${booking.totalPrice.toInt()}", style: const TextStyle(color: Color(0xFF13ec5b), fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Harga", style: TextStyle(color: Colors.grey)),
                    Text("Rp ${booking.totalPrice.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/payment', arguments: args),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF13ec5b),
                    ),
                    child: const Text("Bayar Sekarang"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
