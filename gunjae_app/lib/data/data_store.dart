import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';

abstract class DataStore {
  Future<void> init();

  // User CRUD
  Future<User> createUser(User user);
  Future<User?> getUser(String email, String password);
  Future<User?> getUserById(int id);

  // Spot CRUD (Read mostly)
  Future<List<Spot>> getSpots();
  Future<Spot?> getSpot(int id);
  Future<void> seedSpots(List<Spot> spots); // Helper to init data

  // Booking CRUD
  Future<Booking> createBooking(Booking booking);
  Future<List<Booking>> getBookings(int userId);
  Future<void> updateBooking(Booking booking);
  Future<void> deleteBooking(int id);
}
