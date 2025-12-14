import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/booking.dart';
import '../models/spot.dart';
import '../widgets/bottom_nav.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    final repo = context.read<Repository>();
    // Assume user ID 1
    final bookings = await repo.store.getBookings(1);
    if (mounted) {
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pemesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: _buildTab("Aktif", true)),
                  Expanded(child: _buildTab("Selesai", false)),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _bookings.isEmpty
                    ? const Center(child: Text("Belum ada pesanan"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          final booking = _bookings[index];
                          return _buildBookingCard(booking);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2, onTap: (idx) {
        if (idx == 0) Navigator.pushReplacementNamed(context, '/home');
        if (idx == 3) Navigator.pushReplacementNamed(context, '/profile');
      }),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
      ),
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.pending, size: 14, color: Colors.orange[800]),
                    const SizedBox(width: 4),
                    Text(booking.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange[800])),
                  ],
                ),
              ),
              Text("Order ID: #GJ-${booking.id}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  image: const DecorationImage(
                      image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDOJv1r_r1XpLfj9gAQiN3HkQl1dxoukp7u_EdTWfKqYE33T73VbA11G0FpNW125hCwayFOEh9hya5rm4oSRv4jPRecQKnTxy54FkL1znqFRJu9ldX7a4wQCjJMNr__WbZwiIAaM_JyDSySyT_12GDn6xblhl-wQ6USKNDANNVR_0rbT0_Ne2ldyEHOfX6J7YngruR-3ZBYDL33KVGnTAfj6Y5Rm3WD1ze8CyTSurTA0wFvl6UGwShutjY2FRJqpP7Rfm4b1-XwaqlW"),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Since we don't store spot name in booking, we fetch or assume. Ideally fetch spot.
                    // For now displaying generic or fetching async if needed.
                    FutureBuilder<Spot?>(
                      future: context.read<Repository>().store.getSpot(booking.spotId),
                      builder: (context, snapshot) {
                        return Text(snapshot.data?.name ?? "Camping Spot",
                          style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis);
                      }
                    ),
                    const SizedBox(height: 4),
                    Text("${DateFormat('dd MMM').format(booking.checkIn)} - ${DateFormat('dd MMM').format(booking.checkOut)}",
                         style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text("Rp ${booking.totalPrice.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Lihat Detail"),
            ),
          ),
        ],
      ),
    );
  }
}
