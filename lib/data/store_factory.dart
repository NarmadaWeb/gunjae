import 'data_store.dart';
import 'store_factory_stub.dart'
    if (dart.library.io) 'store_factory_io.dart'
    if (dart.library.html) 'store_factory_web.dart';

DataStore getStore() => createStore();
