import 'package:shared_preferences/shared_preferences.dart';
import 'data_store.dart';
import 'store_stub.dart'
    if (dart.library.io) 'store_mobile.dart'
    if (dart.library.html) 'store_web.dart';

class Repository {
  late DataStore _store;
  int? currentUserId;
  static const String _sessionKey = 'session_user_id';

  Future<void> init() async {
    _store = getStore();
    await _store.init();
    await _loadSession();
  }

  DataStore get store => _store;

  Future<void> login(int userId) async {
    currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, userId);
  }

  Future<void> logout() async {
    currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_sessionKey)) {
      currentUserId = prefs.getInt(_sessionKey);
    }
  }
}
