import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  // Base URL for Xendit API (using Sandbox for development)
  final String _baseUrl = 'https://api.xendit.co';

  // TODO: Replace with your actual Xendit Secret Key
  final String _apiKey = 'xnd_development_YOUR_SECRET_KEY';

  // Create a QR Code payment (Mock/Simulation structure)
  Future<Map<String, dynamic>> createQRCode({
    required String externalId,
    required double amount,
  }) async {
    // In a real app with backend, you would call your backend here.
    // If calling Xendit directly (not recommended for production apps due to secret key exposure),
    // you would do:
    /*
    final response = await http.post(
      Uri.parse('$_baseUrl/qr_codes'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_apiKey:'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'external_id': externalId,
        'type': 'DYNAMIC',
        'callback_url': 'https://your-callback-url.com',
        'amount': amount,
      }),
    );
    */

    // For this demo/simulation without valid keys:
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    return {
      'id': 'qr_${DateTime.now().millisecondsSinceEpoch}',
      'external_id': externalId,
      'amount': amount,
      'qr_string': '00020101021226590014ID.LINKAJA.WWW0118936009180012345678021000123456780303UMI51440014ID.LINKAJA.WWW021000123456780303UMI5204482953033605802ID5913Gunjae Camping6006Lombok61058335262070703A0163046A0B', // Dummy QRIS string
      'status': 'ACTIVE',
      'created': DateTime.now().toIso8601String(),
    };
  }

  // Check payment status (Simulation)
  Future<String> checkPaymentStatus(String qrId) async {
    // In real flow, you check polling or wait for socket/push notif
    await Future.delayed(const Duration(milliseconds: 500));

    // Randomly return success for demo purposes after some time or logic
    // Here we just return PENDING usually, requiring user to click "Check" or waiting
    return 'PENDING';
  }
}
