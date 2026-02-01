import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:provider/provider.dart';
import '../../data/repository.dart';
import '../../models/spot.dart';

class AddCampScreen extends StatefulWidget {
  const AddCampScreen({super.key});

  @override
  State<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends State<AddCampScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descController = TextEditingController();
  final _facilitiesController = TextEditingController();
  bool _isLoading = false;

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final spot = Spot(
          id: 0, // Ignored by createSpot
          name: _nameController.text,
          location: _locationController.text,
          price: double.parse(_priceController.text),
          rating: 5.0, // Default rating for new spot
          imageUrl: _imageController.text,
          description: _descController.text,
          facilities: _facilitiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        );

        await context.read<Repository>().store.createSpot(spot);
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil menambahkan camp!")));
           Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tempat Camp"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInput("Nama Camp", _nameController, icon: MaterialSymbols.camping),
              const SizedBox(height: 16),
              _buildInput("Lokasi", _locationController, icon: Icons.location_on),
              const SizedBox(height: 16),
              _buildInput("Harga per malam", _priceController, icon: Icons.attach_money, type: TextInputType.number, isNumber: true),
              const SizedBox(height: 16),
              _buildInput("URL Gambar", _imageController, icon: Icons.image),
              const SizedBox(height: 16),
              _buildInput("Fasilitas (pisahkan dengan koma)", _facilitiesController, icon: Icons.list),
              const SizedBox(height: 16),
              const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: "Jelaskan tentang tempat ini...",
                ),
                validator: (val) => val!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13ec5b),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {IconData? icon, TextInputType type = TextInputType.text, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
             if (val == null || val.isEmpty) return "Harus diisi";
             if (isNumber && double.tryParse(val) == null) return "Harus berupa angka valid";
             return null;
          },
        ),
      ],
    );
  }
}
