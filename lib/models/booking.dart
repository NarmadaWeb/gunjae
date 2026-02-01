class Booking {
  final int? id;
  final String userId;
  final int spotId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status; // 'active', 'completed', 'cancelled', 'unpaid'
  final String createdAt;
  final String? paymentMethod;
  final String? paymentUrl; // For QR string or redirect URL

  Booking({
    this.id,
    required this.userId,
    required this.spotId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.paymentUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'spotId': spotId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
      'paymentMethod': paymentMethod,
      'paymentUrl': paymentUrl,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      userId: map['userId'].toString(),
      spotId: map['spotId'],
      checkIn: DateTime.parse(map['checkIn']),
      checkOut: DateTime.parse(map['checkOut']),
      guests: map['guests'],
      totalPrice: map['totalPrice'] is String
          ? double.parse(map['totalPrice'])
          : (map['totalPrice'] as num).toDouble(),
      status: map['status'],
      createdAt: map['createdAt'],
      paymentMethod: map['paymentMethod'],
      paymentUrl: map['paymentUrl'],
    );
  }
}
