import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basit_arayuz/pages/uygulama.dart';
import 'package:basit_arayuz/model/kitap_database_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookDatabaseProvider(),
      child: MaterialApp(
        title: 'My App',
        home: UygulamaArayuzu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
