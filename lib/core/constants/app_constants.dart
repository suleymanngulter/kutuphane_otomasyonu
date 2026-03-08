class AppConstants {
  // Database
  static const String databaseName = 'library_database.db';
  static const int databaseVersion = 2;
  static const String booksTable = 'books';
  
  // Admin credentials (should be moved to secure storage in production)
  static const String adminEmail = 'admin@kutuphane.com';
  static const String adminPassword = 'admin123'; // Change this in production!
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Image defaults
  static const String defaultBookImage = 'assets/images/default_book.png';
  
  // Error messages
  static const String errorBookNotFound = 'Kitap bulunamadı';
  static const String errorSaveFailed = 'Kitap kaydedilirken hata oluştu';
  static const String errorDeleteFailed = 'Kitap silinirken hata oluştu';
  static const String errorLoadFailed = 'Kitaplar yüklenirken hata oluştu';
  
  // Success messages
  static const String successBookSaved = 'Kitap başarıyla kaydedildi';
  static const String successBookDeleted = 'Kitap başarıyla silindi';
  static const String successBookAdded = 'Kitap başarıyla eklendi';
}
