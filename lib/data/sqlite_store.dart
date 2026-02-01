import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import '../models/review.dart';
import 'data_store.dart';

class SqliteStore implements DataStore {
  Database? _db;

  @override
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gunjae_camping.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            password TEXT,
            avatarUrl TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE spots(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            location TEXT,
            price REAL,
            rating REAL,
            imageUrl TEXT,
            description TEXT,
            facilities TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE bookings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            spotId INTEGER,
            checkIn TEXT,
            checkOut TEXT,
            guests INTEGER,
            totalPrice REAL,
            status TEXT,
            createdAt TEXT,
            paymentMethod TEXT,
            paymentUrl TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE reviews(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            spotId INTEGER,
            userId TEXT,
            rating REAL,
            comment TEXT,
            createdAt TEXT
          )
        ''');

        // Create initial admin user
        await db.insert('users', User(
          id: 'admin-123',
          name: 'Admin User',
          email: 'admin@gunjae.com',
          password: 'password123',
          avatarUrl: 'https://ui-avatars.com/api/?name=Admin+User'
        ).toMap());
      },
    );

    // Seed spots if empty
    final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM spots'));
    if (count == 0) {
       await _seedInitialSpots();
    }
  }

  Future<void> _seedInitialSpots() async {
     final spots = [
       Spot(id: 1, name: "Gunjae Valley Camp", location: "Gunjae, South Korea", price: 50.0, rating: 4.8, imageUrl: "https://picsum.photos/id/1018/800/600", description: "A beautiful valley camping spot surrounded by nature.", facilities: ["WiFi", "Power", "Water", "Shower"]),
       Spot(id: 2, name: "Mountain View Site", location: "Seorak Mountain", price: 75.0, rating: 4.9, imageUrl: "https://picsum.photos/id/1036/800/600", description: "High altitude camping with breathtaking views.", facilities: ["Power", "Toilet"]),
       Spot(id: 3, name: "Lakeside Retreat", location: "Gapyeong", price: 60.0, rating: 4.5, imageUrl: "https://picsum.photos/id/1043/800/600", description: "Peaceful camping right next to the lake.", facilities: ["Water", "Fishing", "Boat Rental"]),
     ];
     await seedSpots(spots);
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
    await _db!.insert('users', newUser.toMap());
    return newUser;
  }

  @override
  Future<User?> getUser(String email, String password) async {
    final maps = await _db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<User?> getUserById(String id) async {
    final maps = await _db!.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    await _db!.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<List<Spot>> getSpots() async {
    final maps = await _db!.query('spots');
    return maps.map((e) => Spot.fromMap(e)).toList();
  }

  @override
  Future<Spot?> getSpot(int id) async {
    final maps = await _db!.query(
      'spots',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Spot.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> seedSpots(List<Spot> spots) async {
    final batch = _db!.batch();
    for (var spot in spots) {
      final map = spot.toMap();
      map.remove('id'); // Let DB assign ID? Or keep it?
      // If we keep IDs from JSON/Hardcoded, we should insert.
      // But Spot model toMap includes ID.
      // If we want to force ID:
      batch.insert('spots', spot.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  @override
  Future<void> createSpot(Spot spot) async {
    final map = spot.toMap();
    map.remove('id'); // Auto increment
    await _db!.insert('spots', map);
  }

  @override
  Future<void> updateSpot(Spot spot) async {
    final map = spot.toMap();
    map.remove('id'); // ID is used in where clause
    await _db!.update(
      'spots',
      map,
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  @override
  Future<void> deleteSpot(int id) async {
    await _db!.delete(
      'spots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    final map = booking.toMap();
    map.remove('id');
    final id = await _db!.insert('bookings', map);
    return Booking(
      id: id,
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
  }

  @override
  Future<List<Booking>> getBookings(String userId) async {
    final maps = await _db!.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((e) => Booking.fromMap(e)).toList();
  }

  @override
  Future<List<Booking>> getAllBookings() async {
    final maps = await _db!.query('bookings');
    return maps.map((e) => Booking.fromMap(e)).toList();
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    final map = booking.toMap();
    map.remove('id');
    await _db!.update(
      'bookings',
      map,
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  @override
  Future<void> deleteBooking(int id) async {
    await _db!.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> createReview(Review review) async {
    final map = review.toMap();
    map.remove('id');
    await _db!.insert('reviews', map);
  }

  @override
  Future<List<Review>> getReviews(int spotId) async {
    // Need to join to get user name
    // sqflite support rawQuery
    final results = await _db!.rawQuery('''
      SELECT reviews.*, users.name as userName
      FROM reviews
      LEFT JOIN users ON reviews.userId = users.id
      WHERE reviews.spotId = ?
      ORDER BY reviews.createdAt DESC
    ''', [spotId]);

    return results.map((map) {
      // Map join result to Review object
      // Review.fromMap expects 'profiles' map for username if checking Supabase style
      // But my Review.fromMap logic:
      /*
      factory Review.fromMap(Map<String, dynamic> map) {
        return Review(
          ...
          userName: map['profiles'] != null ? map['profiles']['name'] : null,
        );
      }
      */
      // I should update Review.fromMap or manually construct here.
      // Or I can modify map structure to mimic Supabase response if I don't want to change model.
      final mutableMap = Map<String, dynamic>.from(map);
      if (map['userName'] != null) {
        mutableMap['profiles'] = {'name': map['userName']};
      }
      return Review.fromMap(mutableMap);
    }).toList();
  }
}
