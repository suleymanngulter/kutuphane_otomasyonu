import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/kitap.dart';
import '../core/constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.booksTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kitapAdi TEXT NOT NULL,
        stoktaMi INTEGER NOT NULL DEFAULT 1,
        kitapKodu TEXT,
        kitapResmi TEXT,
        kitapAciklamasi TEXT,
        eklenmeTarihi TEXT,
        guncellemeTarihi TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns for version 2
      await db.execute('''
        ALTER TABLE ${AppConstants.booksTable}
        ADD COLUMN eklenmeTarihi TEXT
      ''');
      await db.execute('''
        ALTER TABLE ${AppConstants.booksTable}
        ADD COLUMN guncellemeTarihi TEXT
      ''');
    }
  }

  // CRUD Operations
  Future<int> insertBook(KitapModel book) async {
    final db = await database;
    final now = DateTime.now();
    final bookWithDates = book.copyWith(
      eklenmeTarihi: now,
      guncellemeTarihi: now,
    );
    return await db.insert(
      AppConstants.booksTable,
      bookWithDates.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<KitapModel>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.booksTable,
      orderBy: 'kitapAdi ASC',
    );
    return List.generate(maps.length, (i) => KitapModel.fromMap(maps[i]));
  }

  Future<List<KitapModel>> searchBooks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.booksTable,
      where: 'kitapAdi LIKE ? OR kitapAciklamasi LIKE ? OR kitapKodu LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'kitapAdi ASC',
    );
    return List.generate(maps.length, (i) => KitapModel.fromMap(maps[i]));
  }

  Future<KitapModel?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.booksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return KitapModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBook(KitapModel book) async {
    final db = await database;
    final updatedBook = book.copyWith(guncellemeTarihi: DateTime.now());
    return await db.update(
      AppConstants.booksTable,
      updatedBook.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.booksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
