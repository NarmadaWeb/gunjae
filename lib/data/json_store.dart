import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import '../models/review.dart';
import 'data_store.dart';

class JsonStore implements DataStore {
  List<User> _users = [];
  List<Spot> _spots = [];
  List<Booking> _bookings = [];
  List<Review> _reviews = [];

  @override
  Future<void> init() async {
    try {
      final usersJson = await rootBundle
          .loadString('assets/data/users.json')
          .timeout(const Duration(seconds: 5));
      _users =
          (jsonDecode(usersJson) as List).map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print('Error loading users: $e');
    }

    try {
      final spotsJson = await rootBundle
          .loadString('assets/data/spots.json')
          .timeout(const Duration(seconds: 5));
      _spots =
          (jsonDecode(spotsJson) as List).map((e) => Spot.fromMap(e)).toList();
    } catch (e) {
      print('Error loading spots: $e');
    }

    try {
      final bookingsJson = await rootBundle
          .loadString('assets/data/bookings.json')
          .timeout(const Duration(seconds: 5));
      _bookings = (jsonDecode(bookingsJson) as List)
          .map((e) => Booking.fromMap(e))
          .toList();
    } catch (e) {
      print('Error loading bookings: $e');
    }

    try {
      final reviewsJson = await rootBundle
          .loadString('assets/data/reviews.json')
          .timeout(const Duration(seconds: 5));
      _reviews = (jsonDecode(reviewsJson) as List)
          .map((e) => Review.fromMap(e))
          .toList();
    } catch (e) {
      print('Error loading reviews: $e');
    }
  }

  @override
  Future<User> createUser(User user) async {
    final newUser = User(
      id: user.id ?? 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: user.name,
      email: user.email,
      password: user.password,
      avatarUrl: user.avatarUrl,
    );
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<User?> getUser(String email, String password) async {
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<List<Spot>> getSpots() async {
    return _spots;
  }

  @override
  Future<Spot?> getSpot(int id) async {
    try {
      return _spots.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> seedSpots(List<Spot> spots) async {
    _spots = spots;
  }

  @override
  Future<void> createSpot(Spot spot) async {
    final newSpot = Spot(
      id: (_spots.isNotEmpty ? _spots.map((s) => s.id).reduce((a, b) => a > b ? a : b) : 0) + 1,
      name: spot.name,
      location: spot.location,
      price: spot.price,
      rating: spot.rating,
      imageUrl: spot.imageUrl,
      description: spot.description,
      facilities: spot.facilities,
    );
    _spots.add(newSpot);
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    final newBooking = Booking(
      id: (_bookings.isNotEmpty ? _bookings.map((b) => b.id ?? 0).reduce((a, b) => a > b ? a : b) : 0) + 1,
      userId: booking.userId,
      spotId: booking.spotId,
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      guests: booking.guests,
      totalPrice: booking.totalPrice,
      status: booking.status,
      createdAt: booking.createdAt,
      paymentMethod: booking.paymentMethod,
      paymentUrl: booking.paymentUrl,
    );
    _bookings.add(newBooking);
    return newBooking;
  }

  @override
  Future<List<Booking>> getBookings(String userId) async {
    return _bookings.where((b) => b.userId == userId).toList();
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    _bookings.removeWhere((b) => b.id == id);
  }

  @override
  Future<void> createReview(Review review) async {
    final newReview = Review(
      id: (_reviews.isNotEmpty ? _reviews.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) : 0) + 1,
      spotId: review.spotId,
      userId: review.userId,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
      userName: review.userName,
    );
    _reviews.add(newReview);
  }

  @override
  Future<List<Review>> getReviews(int spotId) async {
    final reviews = _reviews.where((r) => r.spotId == spotId).toList();
    // Populate userName if missing (simulate join)
    for (var i = 0; i < reviews.length; i++) {
      if (reviews[i].userName == null) {
        final user = await getUserById(reviews[i].userId);
        if (user != null) {
           // Review is immutable in model? No, field is final.
           // Recreate it.
           reviews[i] = Review(
             id: reviews[i].id,
             spotId: reviews[i].spotId,
             userId: reviews[i].userId,
             rating: reviews[i].rating,
             comment: reviews[i].comment,
             createdAt: reviews[i].createdAt,
             userName: user.name,
           );
        }
      }
    }
    // Sort desc
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }
}
