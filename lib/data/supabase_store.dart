import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import '../models/review.dart';
import 'data_store.dart';

class SupabaseStore implements DataStore {
  final _client = Supabase.instance.client;

  @override
  Future<void> init() async {
    // Supabase init is done in main.dart
  }

  // User CRUD
  @override
  Future<User> createUser(User user) async {
    final response = await _client.auth.signUp(
      email: user.email,
      password: user.password,
      data: {'name': user.name},
    );

    if (response.user == null) {
      throw Exception('Registration failed');
    }

    return User(
      id: response.user!.id,
      name: user.name,
      email: response.user!.email ?? user.email,
      password: user.password,
    );
  }

  @override
  Future<User?> getUser(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return User(
          id: response.user!.id,
          name: response.user!.userMetadata?['name'] ?? 'User',
          email: response.user!.email ?? email,
          password: password,
        );
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
       final data = await _client.from('profiles').select().eq('id', id).single();
       return User(
         id: data['id'],
         name: data['name'] ?? 'User',
         email: data['email'] ?? '',
         password: '',
         avatarUrl: data['avatarUrl'],
       );
    } catch (e) {
      final currentUser = _client.auth.currentUser;
      if (currentUser != null && currentUser.id == id) {
        return User(
          id: currentUser.id,
          name: currentUser.userMetadata?['name'] ?? 'User',
          email: currentUser.email ?? '',
          password: '',
        );
      }
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    final updates = {
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
    };

    // Update profile table
    await _client.from('profiles').update(updates).eq('id', user.id!);

    // Optionally update Auth metadata if name changed
    await _client.auth.updateUser(
      UserAttributes(
        data: { 'name': user.name },
      ),
    );
  }

  @override
  Future<String> uploadAvatar(File file, String userId) async {
    final fileExt = file.path.split('.').last;
    final fileName = '$userId-${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;

    await _client.storage.from('avatars').upload(
      filePath,
      file,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    final imageUrl = _client.storage.from('avatars').getPublicUrl(filePath);
    return imageUrl;
  }

  // Spot CRUD
  @override
  Future<List<Spot>> getSpots() async {
    final data = await _client.from('spots').select();
    return (data as List).map((map) => Spot.fromMap(map)).toList();
  }

  @override
  Future<Spot?> getSpot(int id) async {
    final data = await _client.from('spots').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return Spot.fromMap(data);
  }

  @override
  Future<void> seedSpots(List<Spot> spots) async {
    for (var spot in spots) {
      final exists = await _client.from('spots').select().eq('id', spot.id).maybeSingle();
      if (exists == null) {
        await _client.from('spots').insert(spot.toMap());
      }
    }
  }

  @override
  Future<void> createSpot(Spot spot) async {
    final map = spot.toMap();
    map.remove('id'); // Let DB assign ID
    await _client.from('spots').insert(map);
  }

  // Booking CRUD
  @override
  Future<Booking> createBooking(Booking booking) async {
    final map = booking.toMap();
    map.remove('id');
    final data = await _client.from('bookings').insert(map).select().single();
    return Booking.fromMap(data);
  }

  @override
  Future<List<Booking>> getBookings(String userId) async {
    final data = await _client.from('bookings').select().eq('userId', userId);
    return (data as List).map((map) => Booking.fromMap(map)).toList();
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    final map = booking.toMap();
    map.remove('id');
    await _client.from('bookings').update(map).eq('id', booking.id!);
  }

  @override
  Future<void> deleteBooking(int id) async {
    await _client.from('bookings').delete().eq('id', id);
  }

  // Review CRUD
  @override
  Future<void> createReview(Review review) async {
    final map = review.toMap();
    map.remove('id');
    // Remove userName before inserting as it is not a column
    map.remove('userName');
    await _client.from('reviews').insert(map);
  }

  @override
  Future<List<Review>> getReviews(int spotId) async {
    // We join with profiles to get user name
    final data = await _client
        .from('reviews')
        .select('*, profiles(name)')
        .eq('spotId', spotId)
        .order('createdAt', ascending: false);

    return (data as List).map((map) => Review.fromMap(map)).toList();
  }
}
