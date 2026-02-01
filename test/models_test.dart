import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gunjae_app/models/spot.dart';
import 'package:gunjae_app/models/review.dart';

void main() {
  test('Spot.fromMap correctly loads facilities from JSON (List)', () async {
    final file = File('assets/data/spots.json');
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Should not throw
    for (var item in jsonList) {
      final spot = Spot.fromMap(item);
      expect(spot.facilities, isA<List<String>>());
      // Check that it's not empty based on current JSON data
      expect(spot.facilities.length, greaterThan(0));
    }
  });

  test('Review.fromMap handles userName correctly', () {
    // Case 1: userName at top level
    final map1 = {
      'id': 1,
      'spotId': 1,
      'userId': 'user1',
      'rating': 5.0,
      'comment': 'Great',
      'createdAt': '2023-01-01',
      'userName': 'John Doe'
    };

    final review1 = Review.fromMap(map1);
    expect(review1.userName, 'John Doe');


    // Case 2: userName in profiles (Supabase style / old logic)
    final map2 = {
      'id': 2,
      'spotId': 1,
      'userId': 'user2',
      'rating': 4.0,
      'comment': 'Good',
      'createdAt': '2023-01-01',
      'profiles': {'name': 'Jane Doe'}
    };
    final review2 = Review.fromMap(map2);
    expect(review2.userName, 'Jane Doe');
  });
}
