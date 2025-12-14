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
  bool _showActive = true; // Tab state

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    final repo = context.read<Repository>();
    if (repo.currentUserId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final bookings = await repo.store.getBookings(repo.currentUserId!);
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Booking> get _filteredBookings {
    final now = DateTime.now();
    return _bookings.where((b) {
      if (_showActive) {
        // Active if status is active AND checkout is in future
        return b.status == 'active' &&
            b.checkOut.isAfter(now.subtract(const Duration(days: 1)));
      } else {
        // Completed if status is completed OR checkout is in past OR cancelled
        // For simplicity, let's say "Selesai" means strictly checkout passed or status completed.
        return b.status == 'completed' ||
            (b.status == 'active' &&
                b.checkOut.isBefore(now.subtract(const Duration(days: 1))));
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pemesanan",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showActive = true),
                      child: _buildTab("Aktif", _showActive),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showActive = false),
                      child: _buildTab("Selesai", !_showActive),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBookings.isEmpty
                    ? const Center(
                        child: Text("Belum ada pesanan di kategori ini"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = _filteredBookings[index];
                          return _buildBookingCard(booking);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 2,
          onTap: (idx) {
            if (idx == 0) Navigator.pushReplacementNamed(context, '/home');
            if (idx == 1) Navigator.pushReplacementNamed(context, '/map');
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
        boxShadow: isActive
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
            : [],
      ),
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey)),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.pending, size: 14, color: Colors.orange[800]),
                    const SizedBox(width: 4),
                    Text(booking.status,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800])),
                  ],
                ),
              ),
              Text("Order ID: #GJ-${booking.id}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FutureBuilder<Spot?>(
                  future:
                      context.read<Repository>().store.getSpot(booking.spotId),
                  builder: (context, snapshot) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image: snapshot.hasData
                            ? DecorationImage(
                                image: NetworkImage(snapshot.data!.imageUrl),
                                fit: BoxFit.cover)
                            : null,
                      ),
                    );
                  }),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Spot?>(
                        future: context
                            .read<Repository>()
                            .store
                            .getSpot(booking.spotId),
                        builder: (context, snapshot) {
                          return Text(snapshot.data?.name ?? "Camping Spot",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis);
                        }),
                    const SizedBox(height: 4),
                    Text(
                        "${DateFormat('dd MMM').format(booking.checkIn)} - ${DateFormat('dd MMM').format(booking.checkOut)}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text("Rp ${booking.totalPrice.toInt()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (booking.status == 'active')
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
