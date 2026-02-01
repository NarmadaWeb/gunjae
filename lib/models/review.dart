class Review {
  final int? id;
  final int spotId;
  final String userId;
  final double rating;
  final String comment;
  final String createdAt;
  final String? userName; // Helper for display if joined

  Review({
    this.id,
    required this.spotId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'spotId': spotId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      spotId: map['spotId'],
      userId: map['userId'],
      rating: map['rating'] is String
          ? double.parse(map['rating'])
          : (map['rating'] as num).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'],
      userName: map['userName'] ??
          (map['profiles'] != null ? map['profiles']['name'] : null),
    );
  }
}
