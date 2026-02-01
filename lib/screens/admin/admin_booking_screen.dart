import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/repository.dart';
import '../../models/booking.dart';
import '../../models/spot.dart';
import '../../models/user.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  bool _isLoading = true;
  List<Booking> _bookings = [];
  Map<int, String> _spotNames = {};
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final store = context.read<Repository>().store;

    try {
      final bookings = await store.getAllBookings();
      final spots = await store.getSpots();

      // Cache spot names
      final spotMap = {for (var s in spots) s.id: s.name};

      // Fetch users
      final userMap = <String, String>{};
      final uniqueUserIds = bookings.map((b) => b.userId).toSet();

      for (var uid in uniqueUserIds) {
        final user = await store.getUserById(uid);
        if (user != null) {
          userMap[uid] = user.name;
        } else {
          userMap[uid] = "Unknown User ($uid)";
        }
      }

      if (mounted) {
        setState(() {
          _bookings = bookings;
          _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
          _spotNames = spotMap;
          _userNames = userMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pemesanan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text("Belum ada pemesanan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    final spotName = _spotNames[booking.spotId] ?? "Unknown Spot";
                    final userName = _userNames[booking.userId] ?? "Unknown User";
                    final fmt = DateFormat('dd MMM yyyy');
                    final range = "${fmt.format(booking.checkIn)} - ${fmt.format(booking.checkOut)}";

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID: #${booking.id}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                _buildStatusBadge(booking.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(spotName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(userName, style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(range, style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total: Rp ${booking.totalPrice.toStringAsFixed(0)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF13ec5b))),
                                Text("${booking.guests} Tamu", style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
      case 'confirmed':
        color = const Color(0xFF13ec5b);
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'unpaid':
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
