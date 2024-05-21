import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'kitap.dart';

class BookDatabaseProvider with ChangeNotifier{
  final String _bookDatabaseName = "bookDatabase.db";
  final String _bookTableName = "book";
  final int _version = 1;
  late Database database;

  String columnKitapAdi = "kitapAdi";
  String columnStoktaMi = "stoktaMi";
  String columnKitapKodu = "kitapKodu";
  String columnKitapResmi = "kitapResmi";
  String columnKitapAciklamasi = "kitapAciklamasi";
  String columnId = "id";

  List<KitapModel> _kitapListesi = [];

  List<KitapModel> get kitapListesi => _kitapListesi;

  BookDatabaseProvider() {
    open();
  }

  Future<void> open() async {
    String path = join(await getDatabasesPath(), _bookDatabaseName);
    database = await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_bookTableName($columnId INTEGER PRIMARY KEY, $columnKitapAdi TEXT, $columnStoktaMi INTEGER, $columnKitapKodu TEXT, $columnKitapResmi TEXT, $columnKitapAciklamasi TEXT)',
        );
      },
    );
  }

  Future<List<KitapModel>> getList() async {
    final List<Map<String, dynamic>> bookMaps = await database.query(_bookTableName);
    return bookMaps.map((map) => KitapModel.fromMap(map)).toList();
  }

  Future<int> insertBook(KitapModel book) async {
    int id = await database.insert(
      _bookTableName,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteBook(int id) async {
    return await database.delete(
      _bookTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    await database.close();
  }
}
