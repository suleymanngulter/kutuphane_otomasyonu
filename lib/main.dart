import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kutuphane_otomasyonu/pages/uygulama.dart';
import 'package:kutuphane_otomasyonu/model/kitap_database_provider.dart';
import 'package:kutuphane_otomasyonu/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookDatabaseProvider(),
      child: MaterialApp(
        title: 'Kütüphane Otomasyonu',
        theme: AppTheme.lightTheme,
        home: const UygulamaArayuzu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
