import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuAvzYrLzBlyh5gkfLpRW6uRmnuIX7lVnSo4tO_G9mRr2dVcF4H5FyTspwdajoRBfp8zhzOC4hIn90H76IkChuSj9YfCv_an8dIbJJgeApRSwZgCYr3-eb1rsD4MCpc5qGZxKV4pg92erzl8V46qEBuPtE9XmJb77srnC9xsa0kRb--LjjeJOiv7hsRGn0CeM1YFTosrKsBV4IAkO9X50W-QcVIv2AKhOJEYEDB31h8DQxg-degEL4Cf9WlB7_Qo78mAvyptUVl37zLR"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 56, left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.camping, color: Color(0xFF13ec5b), size: 40),
                          SizedBox(width: 8),
                          Text(
                            "Gunjae",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.language, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xFFf6f8f6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 30,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Camping Tanpa Ribet",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0d1b12),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Temukan spot terbaik dan sewa tenda di Gunung Jae hanya dalam satu genggaman.",
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  CustomButton(
                    text: "Daftar Akun",
                    icon: Icons.arrow_forward,
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "Masuk",
                    isOutlined: true,
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
