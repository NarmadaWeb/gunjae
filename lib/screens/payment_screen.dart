import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/repository.dart';
import '../models/booking.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'QRIS';
  bool _isProcessing = false;
  Map<String, dynamic>? _paymentData; // To store QR data
  bool _showSuccess = false;

  final PaymentService _paymentService = PaymentService();

  void _initiatePayment() async {
    setState(() => _isProcessing = true);

    // 1. Create Booking first (Pending)
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Booking booking = args['booking'];
    final repo = context.read<Repository>();

    if (repo.currentUserId != null) {
      booking = Booking(
        userId: repo.currentUserId!,
        spotId: booking.spotId,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        guests: booking.guests,
        totalPrice: booking.totalPrice,
        status: 'unpaid', // Initial status
        createdAt: booking.createdAt,
        paymentMethod: _selectedMethod,
      );
    }

    try {
      // Create booking in DB first
      final createdBooking = await repo.store.createBooking(booking);
      final bookingId = createdBooking.id;

      // 2. Call Payment Service (Mock Xendit)
      // Use booking ID as external ID
      final paymentResponse = await _paymentService.createQRCode(
        externalId: 'booking_$bookingId',
        amount: booking.totalPrice,
      );

      // Update Booking with payment URL/data if needed
      // (Skipping DB update for simplicity, assuming we just show QR here)

      setState(() {
        _paymentData = paymentResponse;
        _isProcessing = false;
      });

      // 3. Start Polling for status
      _pollPaymentStatus(paymentResponse['id'], createdBooking);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _pollPaymentStatus(String qrId, Booking booking) async {
    // Simulate polling
    await Future.delayed(const Duration(seconds: 4));

    // Assume success
    if (mounted) {
      setState(() {
        _showSuccess = true;
      });
      // Update DB to active/paid
      final repo = context.read<Repository>();
      final updatedBooking = Booking(
        id: booking.id,
        userId: booking.userId,
        spotId: booking.spotId,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        guests: booking.guests,
        totalPrice: booking.totalPrice,
        status: 'active', // Paid
        createdAt: booking.createdAt,
        paymentMethod: _selectedMethod,
      );
      await repo.store.updateBooking(updatedBooking);

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/history', (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Booking booking = args['booking'];

    if (_showSuccess) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text("Pembayaran Berhasil!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Terima kasih telah memesan.",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text("Mengalihkan...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (_paymentData != null) {
      // Show QR Screen
      return Scaffold(
        appBar: AppBar(title: const Text("Scan QRIS")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Scan QR Code di bawah",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Mendukung Gopay, OVO, Dana, ShopeePay",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: QrImageView(
                  data: _paymentData!['qr_string'],
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text("Menunggu pembayaran...",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Selesaikan pembayaran dalam",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimerBox("00", "JAM"),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(":",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      _buildTimerBox("14", "MNT"),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Metode Pembayaran",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  _buildMethod("QRIS", "Scan QR Code (Recommended)",
                      Icons.qr_code_scanner),
                  const SizedBox(height: 12),
                  _buildMethod("Transfer Bank", "BCA, Mandiri, BNI (Manual)",
                      Icons.account_balance),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Tagihan",
                        style: TextStyle(color: Colors.grey)),
                    Text("Rp ${booking.totalPrice.toInt()}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _initiatePayment,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Text("Bayar Sekarang"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBox(String num, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF13ec5b).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF13ec5b).withOpacity(0.3)),
          ),
          child: Text(num,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF13ec5b))),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMethod(String title, String subtitle, IconData icon) {
    bool isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF13ec5b).withOpacity(0.05)
              : Colors.white,
          border: Border.all(
              color: isSelected ? const Color(0xFF13ec5b) : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? const Color(0xFF13ec5b) : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Icon(icon, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
