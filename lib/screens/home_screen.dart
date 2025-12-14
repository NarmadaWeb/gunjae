import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../data/repository.dart';
import '../models/spot.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Spot> _spots = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSpots();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        // Assuming 3 featured items
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _loadSpots() async {
    final repo = context.read<Repository>();
    // Seed data if empty
    await repo.store.seedSpots([
      Spot(
        id: 1,
        name: "Tepi Danau Jae VIP",
        location: "Gunung Jae, Lombok Barat",
        price: 75000,
        rating: 4.9,
        imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuCXWfYTysoQQamLRz2DcbVjXnZ_uLOqnVEJFIwTIdacXj3MeyCaRz0N0iRNwB9b8rHiWj9Z1aN0wF-KTZPsnAqlGski9fYmz3DSS_JdQEwdA4eKg1AVAUfVogdJUTV-45rpC4aetBmprGLnGUg4o4UJGcktxG4J0hm791-2p4A3Okghqcz6H2cT5W_DRflFG2_KMck73I8j0UqbQiPVqjQYMHJYcvenBmO7mxUKrsutN8HaqzhgahsNqjYcoVNqEZzr_UEPWOdONdKd",
        description:
            "Nikmati pengalaman camping terbaik dengan pemandangan langsung ke Danau.",
        facilities: ["Tenda", "WiFi", "Api Unggun", "Toilet"],
      ),
      Spot(
        id: 2,
        name: "Camping Ground A",
        location: "Tepi Danau, Gunung Jae",
        price: 150000,
        rating: 4.8,
        imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAF3WRyRSiWp51ytpG_xyAoYp49IsVWADw-7-R5_OZmIkfriGa0-eY8CKEtLh4Gny_duAw4O626euPdXk4JgPUUd8Gjm3EMGGIGDh8mRnNdfFpo6Bq0jI0uQIU3u9JLu_DyDct5RovKHC-3d7halxcbn4QwLqYDGYHsj0vPOtVNv9Rkr70P0GAGBSqcoJ_OGZjUtgI_CgiuLyxtTQce22EPcbMPf_Lc7go2MI5P41ln1U-GtmN_RBcLG71fwqTBWoRaJYZ3DED7I7kL",
        description: "Area luas cocok untuk keluarga.",
        facilities: ["Parkir", "Mushola", "Listrik"],
      ),
      Spot(
        id: 3,
        name: "Bukit Bintang Camp",
        location: "Gunung Jae, Atas Bukit",
        price: 90000,
        rating: 4.7,
        imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuD7IXOxRXKE73JLRGxvFYD28i9Ay7idyprRyelUH5-pGr5qmGlydUuGdlb5cpVcCfQyU5R8MQjRQUqg38txlRggKbqGAwnxvwbZ-CVcgFCOQTXeVxi9tONWeDTN9NuV-jraLZZwoD7-hh02D7_eo7bwLDLNAQ6SnWsMCGUF8nl5we-MnOVG8V6oKe1FhlNTc1tPFohzBZv2tolxtdcIvpvxG2ITGfjo-2lIIqQlIXdxi8PqlEm--OezD1YAdY8YhqLdUSmUVVBF-RaA",
        description: "Pemandangan kota dari ketinggian dengan udara sejuk.",
        facilities: ["Tenda", "Api Unggun", "Spot Foto"],
      ),
      Spot(
        id: 4,
        name: "Glamping Narmada",
        location: "Narmada, Lombok Barat",
        price: 350000,
        rating: 4.9,
        imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDwSlbpfOfar3G8Y7qPeoyqag9CEkyWSzbEo1cAfUSNOK2GpuqBQ95fQjrY8Gg9Tpd5FP2HMuH0NgU1uc7boDiJcgrQqbJwE5ov-ZP1EbSnwxCD1lULiiUWP6CX010sEzHMfzIX-A3zE6MgiwS_d_kg47CpxQwNHvkzPdbRWDRtzUZs0FmyW2HF2K6rmqtOeLvCM9BJzDkL7BdOv7HZDwoDs31yvPqHkhkO2QYstaYlW0fif6-XwaYcIOl-Lr1k0_DYjuD9WF-s8AQl",
        description: "Camping mewah dengan fasilitas lengkap seperti hotel.",
        facilities: ["Kasur", "AC", "WiFi", "Sarapan"],
      ),
    ]);

    final spots = await repo.store.getSpots();
    if (mounted) {
      setState(() {
        _spots = spots;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    const Text("Gunjae Camping",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.notifications_outlined,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              // Search
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05), blurRadius: 10)
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari spot camping...",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      icon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
              // Featured Slider
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  height: 192,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _spots.take(3).length, // Show top 3 in slider
                    itemBuilder: (context, index) {
                      final spot = _spots[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(spot.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black87, Colors.transparent],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text("POPULER",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(spot.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(spot.location,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Categories
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip("Semua", true),
                    _buildCategoryChip("Tepi Danau", false),
                    _buildCategoryChip("View Gunung", false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // List
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _spots.length,
                itemBuilder: (context, index) {
                  final spot = _spots[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/detail',
                        arguments: spot),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: spot.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(spot.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 14, color: Colors.grey),
                                            Text(spot.location,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star,
                                              size: 14, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(spot.rating.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Mulai dari",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey)),
                                        RichText(
                                          text: TextSpan(
                                            text: "Rp ${spot.price.toInt()}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            children: const [
                                              TextSpan(
                                                  text: "/malam",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/detail',
                                          arguments: spot),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      child: const Text("Pilih",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (idx) {
            if (idx == 1) Navigator.pushReplacementNamed(context, '/map');
            if (idx == 2) Navigator.pushReplacementNamed(context, '/history');
            if (idx == 3) Navigator.pushReplacementNamed(context, '/profile');
          }),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF13ec5b) : Colors.white,
          foregroundColor: isSelected ? Colors.black : Colors.black87,
          elevation: isSelected ? 2 : 0,
          side: isSelected
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(label),
      ),
    );
  }
}
