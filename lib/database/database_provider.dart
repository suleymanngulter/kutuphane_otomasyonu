
import 'package:basit_arayuz/model/kitap_database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:basit_arayuz/model/kitap.dart';


abstract class DatabaseProvider<T extends BookDatabaseProvider> {
  Future open();
  Future<T> getItem(int id);
  Future<List<T>> getList();
  Future<bool> updateItem(int id, KitapModel model);
  Future<bool> removeItem(int id);
  Future<bool> insertItem(KitapModel kitap);

  late Database database;

  Future<void> close() async {
    await database.close();
  }
}