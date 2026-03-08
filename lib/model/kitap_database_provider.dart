import 'package:flutter/material.dart';
import '../model/kitap.dart';
import '../services/database_service.dart';

class BookDatabaseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<KitapModel> _kitapListesi = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KitapModel> get kitapListesi => _kitapListesi;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  BookDatabaseProvider() {
    loadBooks();
  }

  Future<void> loadBooks() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _kitapListesi = await _databaseService.getAllBooks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Kitaplar yüklenirken hata oluştu: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      await loadBooks();
      return;
    }
    
    _setLoading(true);
    _errorMessage = null;
    try {
      _kitapListesi = await _databaseService.searchBooks(query);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Arama sırasında hata oluştu: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addBook(KitapModel book) async {
    _errorMessage = null;
    try {
      await _databaseService.insertBook(book);
      await loadBooks();
      return true;
    } catch (e) {
      _errorMessage = 'Kitap eklenirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBook(KitapModel book) async {
    if (book.id == null) return false;
    
    _errorMessage = null;
    try {
      await _databaseService.updateBook(book);
      await loadBooks();
      return true;
    } catch (e) {
      _errorMessage = 'Kitap güncellenirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBook(int id) async {
    _errorMessage = null;
    try {
      final result = await _databaseService.deleteBook(id);
      if (result > 0) {
        await loadBooks();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Kitap silinirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
