import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/spot.dart';
import '../models/booking.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now().add(const Duration(days: 1));
  int _guests = 4;

  void _pickDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut.isBefore(_checkIn)) {
            _checkOut = _checkIn.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Spot spot = ModalRoute.of(context)!.settings.arguments as Spot;
    final nights = _checkOut.difference(_checkIn).inDays;
    final totalPrice = spot.price * nights;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Pemesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Selected Spot
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("TERPILIH", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 4),
                              Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  Text(spot.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(spot.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Date Picker
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Color(0xFF13ec5b)),
                      const SizedBox(width: 8),
                      const Text("Jadwal Camping", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDateInput("Check-in", _checkIn, true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDateInput("Check-out", _checkOut, false)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Guests
                   Row(
                    children: [
                      const Icon(Icons.groups, color: Color(0xFF13ec5b)),
                      const SizedBox(width: 8),
                      const Text("Jumlah Peserta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dewasa", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Usia 12+ tahun", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => setState(() { if(_guests > 1) _guests--; }),
                              icon: const Icon(Icons.remove),
                            ),
                            Text("$_guests", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            IconButton(
                              onPressed: () => setState(() { _guests++; }),
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(backgroundColor: const Color(0xFF13ec5b)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Harga", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text("Rp ${totalPrice.toInt()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final booking = Booking(
                        userId: 1, // Mock user ID for now, or get from context/repo
                        spotId: spot.id,
                        checkIn: _checkIn,
                        checkOut: _checkOut,
                        guests: _guests,
                        totalPrice: totalPrice,
                        status: 'active',
                        createdAt: DateTime.now().toIso8601String(),
                      );
                      Navigator.pushNamed(context, '/confirm', arguments: {'spot': spot, 'booking': booking});
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text("Lanjut Pembayaran"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput(String label, DateTime date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _pickDate(isCheckIn),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(DateFormat('dd MMM yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
