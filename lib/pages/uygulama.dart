import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kutuphane_otomasyonu/model/kitap_database_provider.dart';
import 'package:kutuphane_otomasyonu/pages/admin_giris.dart';
import 'package:kutuphane_otomasyonu/pages/kitap_menusu.dart';
import 'package:kutuphane_otomasyonu/core/constants/app_constants.dart';

class UygulamaArayuzu extends StatefulWidget {
  const UygulamaArayuzu({super.key});

  @override
  State<UygulamaArayuzu> createState() => _UygulamaArayuzuState();
}

class _UygulamaArayuzuState extends State<UygulamaArayuzu> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<BookDatabaseProvider>().loadBooks();
      }
    });
  }

  void _performSearch(String query) {
    context.read<BookDatabaseProvider>().searchBooks(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Kitap ara...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
              )
            : const Text('Kütüphane Otomasyonu'),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _toggleSearch,
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: _toggleSearch,
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.login),
              tooltip: 'Admin Girişi',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminGiris(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Consumer<BookDatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'Bir hata oluştu',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadBooks();
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (provider.kitapListesi.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz kitap eklenmemiş',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadBooks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: provider.kitapListesi.length,
              itemBuilder: (context, index) {
                return KitapMenusu(
                  kitap: provider.kitapListesi[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
