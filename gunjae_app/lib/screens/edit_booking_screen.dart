import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/booking.dart';
import '../models/spot.dart';

class EditBookingScreen extends StatefulWidget {
  const EditBookingScreen({super.key});

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  late Booking _booking;
  late Spot _spot;
  bool _initialized = false;

  // Form state
  late DateTime _checkIn;
  late DateTime _checkOut;
  late int _guests;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _booking = args['booking'];
      _spot = args['spot']; // Pass spot to display details

      _checkIn = _booking.checkIn;
      _checkOut = _booking.checkOut;
      _guests = _booking.guests;
      _initialized = true;
    }
  }

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

  void _updateBooking() async {
    final repo = context.read<Repository>();
    final nights = _checkOut.difference(_checkIn).inDays;
    final newTotalPrice = _spot.price * nights;

    final updatedBooking = Booking(
      id: _booking.id,
      userId: _booking.userId,
      spotId: _booking.spotId,
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
      totalPrice: newTotalPrice,
      status: _booking.status,
      createdAt: _booking.createdAt,
    );

    try {
      await repo.store.updateBooking(updatedBooking);
      if (mounted) {
        Navigator.pop(context, true); // Return result to refresh previous screen
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _cancelBooking() async {
    // Logic to cancel (delete or set status to cancelled)
    // Here we will set status to cancelled or delete based on user intent.
    // The UI says "Batalkan Pesanan Ini".
    final repo = context.read<Repository>();
    try {
      await repo.store.deleteBooking(_booking.id!); // Or update status
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/history', (route) => false);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final nights = _checkOut.difference(_checkIn).inDays;
    final newTotalPrice = _spot.price * nights;
    final priceDiff = newTotalPrice - _booking.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF13ec5b).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text("Terkonfirmasi", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("#GJ-${_booking.id}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(_spot.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(_spot.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(_spot.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Form
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Ubah Jadwal & Peserta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => _pickDate(true),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Tanggal Masuk", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Text(DateFormat('dd MMM yyyy').format(_checkIn), style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Durasi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: Center(child: Text("$nights Mlm", style: const TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(0xFFe7f3eb),
                                  child: Icon(Icons.group, size: 16, color: Color(0xFF13ec5b)),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Jumlah Peserta", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Maks. 6 orang/tenda", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]!),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => setState(() { if(_guests > 1) _guests--; }),
                                    child: const CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.remove, size: 16, color: Colors.grey)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text("$_guests", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  InkWell(
                                    onTap: () => setState(() { _guests++; }),
                                    child: const CircleAvatar(radius: 14, backgroundColor: Color(0xFF13ec5b), child: Icon(Icons.add, size: 16, color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price Diff
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFe7f3eb), Color(0xFFf0fdf4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF13ec5b).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rincian Perubahan", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Sebelumnya", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("Rp ${_booking.totalPrice.toInt()}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Selisih Biaya", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("${priceDiff >= 0 ? '+' : '-'} Rp ${priceDiff.abs().toInt()}",
                              style: TextStyle(color: priceDiff >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Baru", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Rp ${newTotalPrice.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _cancelBooking,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: const Text("Batalkan Pesanan Ini", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13ec5b),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Simpan Perubahan"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
