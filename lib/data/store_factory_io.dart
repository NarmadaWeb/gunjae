import 'data_store.dart';
import 'sqlite_store.dart';

DataStore createStore() => SqliteStore();
