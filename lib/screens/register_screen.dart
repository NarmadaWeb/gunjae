import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/user.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    final repo = context.read<Repository>();
    // Simple basic validation
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Isi semua data')));
      return;
    }

    try {
      final newUser = await repo.store.createUser(User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ));
      repo.login(newUser.id!); // Set session
      if (mounted)
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Daftar Akun",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDqDC_hohT5AaArWl7lJsLYHZOCeJ7kIuX2HVF75sXsPqZEsvSIBWPtK3iZ1oKK1ax3hr7w638XOPljuZUF11IR-TIMHTIi8bIAlarMn23oqjgySNuVAA1wTFE-KfEj3ou6MDc-_kY1lTuweakKgYbu32rsiIHdONme0cNEgNamw_dVBhHE6kVnJ_2qflBLSg0h0Q55AVm9kzu5zc-kf2lQnc8fno5XDquxAzRIah5lZFTc-bwJVJDqpkkgVNNnmRRB1rTnFIpV-qQ2"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x1A0e2e16),
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Selamat Datang di Gunjae!",
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Mulai petualangan campingmu di Gunung Jae, Lombok sekarang.",
              style: GoogleFonts.notoSans(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            _buildInput("Nama Lengkap", Icons.person, _nameController),
            const SizedBox(height: 20),
            _buildInput("Email", Icons.mail, _emailController,
                type: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildInput("Kata Sandi", Icons.lock, _passwordController,
                obscure: true),
            const SizedBox(height: 32),
            CustomButton(
                text: "Daftar Sekarang",
                icon: Icons.arrow_forward,
                onPressed: _register),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Masuk disini",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            prefixIcon: Icon(icon, color: const Color(0xFF4c9a66)),
            hintText: "Masukkan ${label.toLowerCase()}",
          ),
        ),
      ],
    );
  }
}
