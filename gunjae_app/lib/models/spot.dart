class Spot {
  final int id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> facilities;

  Spot({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.facilities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'facilities': facilities.join(','), // Simple comma separated for sqlite
    };
  }

  factory Spot.fromMap(Map<String, dynamic> map) {
    return Spot(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      price: map['price'] is String ? double.parse(map['price']) : (map['price'] as num).toDouble(),
      rating: map['rating'] is String ? double.parse(map['rating']) : (map['rating'] as num).toDouble(),
      imageUrl: map['imageUrl'],
      description: map['description'],
      facilities: (map['facilities'] as String).split(','),
    );
  }
}
