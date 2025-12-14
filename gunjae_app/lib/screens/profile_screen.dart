import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/repository.dart';
import '../models/booking.dart';
import '../models/spot.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Booking> _activeBookings = [];

  @override
  void initState() {
    super.initState();
    _loadActiveBookings();
  }

  void _loadActiveBookings() async {
    final repo = context.read<Repository>();
    // Assume user ID 1
    final bookings = await repo.store.getBookings(1);
    // Filter for active bookings (assuming status 'active' and checkout future)
    final active = bookings.where((b) => b.status == 'active').toList();
    if (mounted) {
      setState(() {
        _activeBookings = active;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Profil Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuD1UPIirTtowg4skYmP2CcpFgCf8aXDwY6Z33M6RibgQlcX8HQGRU5YZ5YKav_QPehiTjh71LLRtFnosB-x_t3Crbc83odzdKN-tsfpizwGc_3fnMASJWwett5MTDOOQfCKuxvRV0zzjqQYiFVWRa-h3cZhQqPZOY-pT3jc5truWGU2pNVTR1Fh4gNrvttWSHVcILTN0ubbmlx39ODd-ple1P3ty7_fuxe0IEEXGa7veqLYqOrPQvcUWtDDhwIrLkfX0ybgbWzmsLtQ"),
                  ),
                  const SizedBox(height: 16),
                  const Text("Budi Santoso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 4),
                        Text("Member Gold",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton(context, "Favorit", Icons.favorite, Colors.red),
                  _buildMenuButton(context, "Ulasan", Icons.reviews, Colors.amber),
                  _buildMenuButton(context, "Voucher", Icons.local_offer, Colors.blue),
                ],
              ),
              const SizedBox(height: 32),
              // Reservasi Aktif Section
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Reservasi Aktif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/history'),
                      child: Text("Lihat Semua", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              if (_activeBookings.isNotEmpty)
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _activeBookings.length,
                    itemBuilder: (context, index) {
                      return _buildActiveBookingCard(context, _activeBookings[index]);
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Tidak ada reservasi aktif.", style: TextStyle(color: Colors.grey)),
                ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Akun Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: const Icon(Icons.email, color: Colors.grey),
                        ),
                        title: const Text("Email", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        subtitle: const Text("budi@example.com", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3, onTap: (idx) {
        if (idx == 0) Navigator.pushReplacementNamed(context, '/home');
        if (idx == 2) Navigator.pushReplacementNamed(context, '/history');
      }),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActiveBookingCard(BuildContext context, Booking booking) {
    return FutureBuilder<Spot?>(
      future: context.read<Repository>().store.getSpot(booking.spotId),
      builder: (context, snapshot) {
        final spot = snapshot.data;
        if (spot == null) return const SizedBox.shrink();

        return Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(spot.imageUrl, height: 128, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${DateFormat('d').format(booking.checkIn)} - ${DateFormat('d MMM').format(booking.checkOut)}",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        Text(spot.location, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final repo = context.read<Repository>();
                              await repo.store.deleteBooking(booking.id!);
                              _loadActiveBookings();
                            },
                            icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                            label: const Text("Batal", style: TextStyle(color: Colors.red, fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red[100]!),
                              backgroundColor: Colors.red[50],
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/edit_booking', arguments: {'booking': booking, 'spot': spot});
                              _loadActiveBookings();
                            },
                            icon: const Icon(Icons.edit_calendar, size: 16),
                            label: const Text("Ubah", style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
