import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import '../models/review.dart';

abstract class DataStore {
  Future<void> init();

  // User CRUD
  Future<User> createUser(User user);
  Future<User?> getUser(String email, String password);
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);

  // Spot CRUD (Read mostly)
  Future<List<Spot>> getSpots();
  Future<Spot?> getSpot(int id);
  Future<void> seedSpots(List<Spot> spots); // Helper to init data
  Future<void> createSpot(Spot spot);
  Future<void> updateSpot(Spot spot);
  Future<void> deleteSpot(int id);

  // Booking CRUD
  Future<Booking> createBooking(Booking booking);
  Future<List<Booking>> getBookings(String userId);
  Future<List<Booking>> getAllBookings();
  Future<void> updateBooking(Booking booking);
  Future<void> deleteBooking(int id);

  // Review CRUD
  Future<void> createReview(Review review);
  Future<List<Review>> getReviews(int spotId);
}
