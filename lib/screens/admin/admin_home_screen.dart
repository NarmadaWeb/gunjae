import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository.dart';
import '../../models/spot.dart';
import 'add_camp_screen.dart';
import 'admin_booking_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Spot> _spots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  void _loadSpots() async {
    final repo = context.read<Repository>();
    final spots = await repo.store.getSpots();
    if (mounted) {
      setState(() {
        _spots = spots;
        _isLoading = false;
      });
    }
  }

  void _deleteSpot(Spot spot) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Hapus ${spot.name}?"),
        content: const Text("Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<Repository>().store.deleteSpot(spot.id);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Spot dihapus")));
        _loadSpots();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
               // When admin switches to user view, we replace the route so they land on home
               Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
            icon: const Icon(Icons.person_outline, color: Color(0xFF13ec5b)),
            label: const Text("User View", style: TextStyle(color: Color(0xFF13ec5b), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selamat Datang, Admin",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: const Color(0xFF13ec5b).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.landscape,
                                    size: 32, color: Color(0xFF13ec5b)),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Total Spots",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12)),
                                    Text("${_spots.length}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.orange.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const AdminBookingScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.list_alt,
                                      size: 32, color: Colors.orange),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pemesanan",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12)),
                                      Text("Lihat",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text("Daftar Camp",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _spots.length,
                    itemBuilder: (context, index) {
                      final spot = _spots[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                               spot.imageUrl,
                               width: 60,
                               height: 60,
                               fit: BoxFit.cover,
                               errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300], width: 60, height: 60, child: const Icon(Icons.broken_image)),
                            ),
                          ),
                          title: Text(spot.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(spot.location),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AddCampScreen(spot: spot)),
                                  ).then((_) => _loadSpots());
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSpot(spot),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/detail',
                                arguments: spot);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/admin/add_camp').then((_) => _loadSpots());
        },
        backgroundColor: const Color(0xFF13ec5b),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Camp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
