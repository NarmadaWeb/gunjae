import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import '../data/repository.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final repo = context.read<Repository>();
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi email dan password')));
      return;
    }

    try {
      final user = await repo.store
          .getUser(_emailController.text, _passwordController.text);
      if (user != null) {
        repo.login(user.id!); // Set session
        if (mounted) {
          if (_emailController.text == 'admin@gunjae.com') {
             Navigator.pushNamedAndRemoveUntil(context, '/admin_home', (route) => false);
          } else {
             Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        }
      } else {
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login gagal')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Icon(MaterialSymbols.camping,
                          color: Theme.of(context).primaryColor, size: 32),
                      const SizedBox(width: 8),
                      const Text("Gunjae",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Selamat Datang Kembali",
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                      "Masuk untuk melanjutkan petualangan camping Anda di Gunung Jae.",
                      style: GoogleFonts.notoSans(
                          fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),
                  _buildInput("Email", Icons.mail, _emailController,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildInput("Kata Sandi", Icons.lock, _passwordController,
                      obscure: true),
                  const SizedBox(height: 32),
                  CustomButton(text: "Masuk", onPressed: _login),
                  const Spacer(),
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/register'),
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: const TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Daftar Sekarang",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
      String label, IconData icon, TextEditingController controller,
      {bool obscure = false, TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: label == "Email" ? "nama@contoh.com" : "••••••••",
            suffixIcon: obscure
                ? const Icon(Icons.visibility_off, color: Colors.grey)
                : null,
          ),
        ),
      ],
    );
  }
}
