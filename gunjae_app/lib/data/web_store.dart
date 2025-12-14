import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import 'data_store.dart';

class WebStore implements DataStore {
  late SharedPreferences _prefs;

  static const String _usersKey = 'users';
  static const String _spotsKey = 'spots';
  static const String _bookingsKey = 'bookings';

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- User ---
  @override
  Future<User> createUser(User user) async {
    List<User> users = await _getUsers();
    // Simple auto-increment ID
    int nextId = (users.isEmpty ? 0 : users.last.id ?? 0) + 1;
    User newUser = User(
      id: nextId,
      name: user.name,
      email: user.email,
      password: user.password,
    );
    users.add(newUser);
    await _saveUsers(users);
    return newUser;
  }

  @override
  Future<User?> getUser(String email, String password) async {
    List<User> users = await _getUsers();
    try {
      return users.firstWhere((u) => u.email == email && u.password == password);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUserById(int id) async {
    List<User> users = await _getUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> _getUsers() async {
    String? jsonStr = _prefs.getString(_usersKey);
    if (jsonStr == null) return [];
    List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => User.fromMap(e)).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    String jsonStr = jsonEncode(users.map((u) => u.toMap()).toList());
    await _prefs.setString(_usersKey, jsonStr);
  }

  // --- Spots ---
  @override
  Future<List<Spot>> getSpots() async {
    String? jsonStr = _prefs.getString(_spotsKey);
    if (jsonStr == null) return [];
    List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => Spot.fromMap(e)).toList();
  }

  @override
  Future<Spot?> getSpot(int id) async {
    List<Spot> spots = await getSpots();
    try {
      return spots.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> seedSpots(List<Spot> spots) async {
    List<Spot> existing = await getSpots();
    if (existing.isEmpty) {
      String jsonStr = jsonEncode(spots.map((s) => s.toMap()).toList());
      await _prefs.setString(_spotsKey, jsonStr);
    }
  }

  // --- Bookings ---
  @override
  Future<Booking> createBooking(Booking booking) async {
    List<Booking> bookings = await _getBookingsAll();
    int nextId = (bookings.isEmpty ? 0 : bookings.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1;
    Booking newBooking = Booking(
      id: nextId,
      userId: booking.userId,
      spotId: booking.spotId,
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      guests: booking.guests,
      totalPrice: booking.totalPrice,
      status: booking.status,
      createdAt: booking.createdAt,
    );
    bookings.add(newBooking);
    await _saveBookings(bookings);
    return newBooking;
  }

  @override
  Future<List<Booking>> getBookings(int userId) async {
    List<Booking> all = await _getBookingsAll();
    return all.where((b) => b.userId == userId).toList();
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    List<Booking> bookings = await _getBookingsAll();
    int index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      bookings[index] = booking;
      await _saveBookings(bookings);
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    List<Booking> bookings = await _getBookingsAll();
    bookings.removeWhere((b) => b.id == id);
    await _saveBookings(bookings);
  }

  Future<List<Booking>> _getBookingsAll() async {
    String? jsonStr = _prefs.getString(_bookingsKey);
    if (jsonStr == null) return [];
    List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => Booking.fromMap(e)).toList();
  }

  Future<void> _saveBookings(List<Booking> bookings) async {
    String jsonStr = jsonEncode(bookings.map((b) => b.toMap()).toList());
    await _prefs.setString(_bookingsKey, jsonStr);
  }
}
