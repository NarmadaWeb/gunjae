import 'data_store.dart';
import 'store_stub.dart'
    if (dart.library.io) 'store_mobile.dart'
    if (dart.library.html) 'store_web.dart';

class Repository {
  late DataStore _store;

  Future<void> init() async {
    _store = getStore();
    await _store.init();
  }

  DataStore get store => _store;
}
