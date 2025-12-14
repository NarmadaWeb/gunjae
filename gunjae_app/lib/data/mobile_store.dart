import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/spot.dart';
import '../models/booking.dart';
import 'data_store.dart';

class MobileStore implements DataStore {
  late Database _db;

  @override
  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'gunjae.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          password TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE Spots (
          id INTEGER PRIMARY KEY,
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
        CREATE TABLE Bookings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          spotId INTEGER,
          checkIn TEXT,
          checkOut TEXT,
          guests INTEGER,
          totalPrice REAL,
          status TEXT,
          createdAt TEXT,
          FOREIGN KEY (userId) REFERENCES Users (id),
          FOREIGN KEY (spotId) REFERENCES Spots (id)
        )
      ''');
    });
  }

  // --- User ---
  @override
  Future<User> createUser(User user) async {
    int id = await _db.insert('Users', user.toMap());
    return User(id: id, name: user.name, email: user.email, password: user.password);
  }

  @override
  Future<User?> getUser(String email, String password) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'Users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<User?> getUserById(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'Users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // --- Spots ---
  @override
  Future<List<Spot>> getSpots() async {
    List<Map<String, dynamic>> maps = await _db.query('Spots');
    return List.generate(maps.length, (i) {
      return Spot.fromMap(maps[i]);
    });
  }

  @override
  Future<Spot?> getSpot(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'Spots',
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
    var count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM Spots'));
    if (count == 0) {
      Batch batch = _db.batch();
      for (var spot in spots) {
        batch.insert('Spots', spot.toMap());
      }
      await batch.commit(noResult: true);
    }
  }

  // --- Bookings ---
  @override
  Future<Booking> createBooking(Booking booking) async {
    var map = booking.toMap();
    map.remove('id'); // Auto increment
    int id = await _db.insert('Bookings', map);
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
    );
  }

  @override
  Future<List<Booking>> getBookings(int userId) async {
    List<Map<String, dynamic>> maps = await _db.query(
      'Bookings',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Booking.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    await _db.update(
      'Bookings',
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  @override
  Future<void> deleteBooking(int id) async {
    await _db.delete(
      'Bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
