import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kutuphane_otomasyonu/model/kitap.dart';
import 'package:kutuphane_otomasyonu/model/kitap_database_provider.dart';
import 'package:kutuphane_otomasyonu/pages/uygulama.dart';
import 'package:kutuphane_otomasyonu/pages/kitap_menusu.dart';
import 'package:kutuphane_otomasyonu/core/constants/app_constants.dart';

class AdminSayfasi extends StatefulWidget {
  const AdminSayfasi({super.key});

  @override
  State<AdminSayfasi> createState() => _AdminSayfasiState();
}

class _AdminSayfasiState extends State<AdminSayfasi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookDatabaseProvider>().loadBooks();
    });
  }

  void _showDeleteBookDialog() {
    final provider = context.read<BookDatabaseProvider>();
    
    if (provider.kitapListesi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silinecek kitap bulunamadı'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedBookId;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Kitap Sil'),
              content: SizedBox(
                width: double.maxFinite,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Silinecek Kitabı Seçin',
                    border: OutlineInputBorder(),
                  ),
                  items: provider.kitapListesi.map((kitap) {
                    return DropdownMenuItem<String>(
                      value: kitap.id.toString(),
                      child: Text(
                        '${kitap.kitapAdi}${kitap.kitapKodu != null ? " (${kitap.kitapKodu})" : ""}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedBookId = value;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: selectedBookId == null
                      ? null
                      : () async {
                          if (selectedBookId != null) {
                            final success = await provider.deleteBook(
                              int.parse(selectedBookId!),
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? AppConstants.successBookDeleted
                                        : AppConstants.errorDeleteFailed,
                                  ),
                                  backgroundColor: success
                                      ? AppConstants.successColor
                                      : AppConstants.errorColor,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sil'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showKitapEkleForm() {
    final formKey = GlobalKey<FormState>();
    String yeniKitapAdi = '';
    String yeniKitapAciklamasi = '';
    String yeniKitapResmi = '';
    String yeniKitapKodu = '';
    bool stoktaMi = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Yeni Kitap Ekle'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kitap Adı *',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => yeniKitapAdi = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kitap adı zorunludur';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kitap Kodu',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => yeniKitapKodu = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kitap Açıklaması',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) => yeniKitapAciklamasi = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kitap Resmi URL',
                          border: OutlineInputBorder(),
                          hintText: 'https://example.com/image.jpg',
                        ),
                        onChanged: (value) => yeniKitapResmi = value,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Stokta Var'),
                        value: stoktaMi,
                        onChanged: (value) {
                          setDialogState(() {
                            stoktaMi = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final provider = context.read<BookDatabaseProvider>();
                      final yeniKitap = KitapModel(
                        kitapAdi: yeniKitapAdi,
                        kitapAciklamasi: yeniKitapAciklamasi.isEmpty
                            ? null
                            : yeniKitapAciklamasi,
                        kitapResmi:
                            yeniKitapResmi.isEmpty ? null : yeniKitapResmi,
                        kitapKodu:
                            yeniKitapKodu.isEmpty ? null : yeniKitapKodu,
                        stoktaMi: stoktaMi,
                      );

                      final success = await provider.addBook(yeniKitap);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? AppConstants.successBookAdded
                                  : AppConstants.errorSaveFailed,
                            ),
                            backgroundColor: success
                                ? AppConstants.successColor
                                : AppConstants.errorColor,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Ana Sayfaya Dön',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UygulamaArayuzu(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<BookDatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                    onPressed: () => provider.loadBooks(),
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
                  const Text(
                    'Henüz kitap eklenmemiş',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yeni kitap eklemek için + butonuna tıklayın',
                    style: TextStyle(color: Colors.grey[600]),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showKitapEkleForm,
            tooltip: 'Kitap Ekle',
            heroTag: 'add',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showDeleteBookDialog,
            tooltip: 'Kitap Sil',
            heroTag: 'delete',
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
