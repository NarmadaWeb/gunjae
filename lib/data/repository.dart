import 'package:shared_preferences/shared_preferences.dart';
import 'data_store.dart';
import 'store_factory.dart';

class Repository {
  late DataStore _store;
  String? currentUserId;
  static const String _sessionKey = 'session_user_id';

  Future<void> init() async {
    _store = getStore();
    await _store.init();
    await _loadSession();
  }

  DataStore get store => _store;

  Future<void> login(String userId) async {
    currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, userId);
  }

  Future<void> logout() async {
    currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_sessionKey)) {
      try {
        currentUserId = prefs.getString(_sessionKey);
      } catch (e) {
        // Handle case where user ID was stored as int (legacy)
        try {
          final intId = prefs.getInt(_sessionKey);
          if (intId != null) {
            currentUserId = intId.toString();
            // Migrate to string
            await prefs.setString(_sessionKey, currentUserId!);
          }
        } catch (_) {
          await prefs.remove(_sessionKey);
        }
      }
    }
  }
}
