import 'package:basit_arayuz/pages/uygulama.dart';
import 'package:flutter/material.dart';
import 'package:basit_arayuz/model/kitap.dart';
import 'package:basit_arayuz/model/kitap_database_provider.dart';
import 'kitap_menusu.dart';


class AdminSayfasi extends StatefulWidget {
  @override
  _AdminSayfasiState createState() => _AdminSayfasiState();
}

class _AdminSayfasiState extends State<AdminSayfasi> {
  BookDatabaseProvider provider = BookDatabaseProvider();
  late List<KitapModel> kitapList;

  @override
  void initState() {
    super.initState();
    kitapList = [];
    updateListView();
  }

  void updateListView() {
    provider.getList().then((kitaplar) {
      setState(() {
        kitapList = kitaplar;
      });
    });
  }


  void _deleteKitap(int kitapKodu) {
    provider.deleteBook(kitapKodu).then((result) {
      if (result != 0) {
        _showSnackBar(context, 'Kitap Başarıyla Silindi');
        updateListView();
      }
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showDeleteBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String silinecekKitapAdi = '';
        return AlertDialog(
          title: Text('Kitap Silme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Silmek istediğiniz kitabı seçin'),
              TextField(
                decoration: InputDecoration(labelText: 'Kitap Adı'),
                onChanged: (value) {
                  silinecekKitapAdi = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                KitapModel? silinecekKitap;
                try {
                  silinecekKitap = kitapList.firstWhere(
                        (kitap) => kitap.kitapAdi == silinecekKitapAdi,
                  );
                } catch (e) {

                  silinecekKitap = null;
                }

                if (silinecekKitap != null) {
                  _deleteKitap(silinecekKitap.kitapKodu as int);
                } else {
                  _showSnackBar(context, 'Kitap bulunamadı');
                }

                Navigator.of(context).pop();
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }


  void _showKitapEkleForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String yeniKitapAdi = '';
        String yeniKitapAciklamasi = '';
        String yeniKitapResmi = '';

        return AlertDialog(
          title: Text('Yeni Kitap Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Kitap Adı'),
                onChanged: (value) {
                  yeniKitapAdi = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Kitap Açıklaması'),
                onChanged: (value) {
                  yeniKitapAciklamasi = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Kitap Resmi URL'),
                onChanged: (value) {
                  yeniKitapResmi = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                KitapModel yeniKitap = KitapModel(
                  kitapAdi: yeniKitapAdi,
                  kitapAciklamasi: yeniKitapAciklamasi,
                  kitapResmi: yeniKitapResmi,
                );

                provider.insertBook(yeniKitap).then((id) {
                  _showSnackBar(context, 'Kitap Başarıyla Eklendi');
                  updateListView();
                });

                Navigator.of(context).pop();
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      appBar: AppBar(
        title: Text('Admin Sayfası'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: kitapList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: kitapList.length,
        itemBuilder: (context, index) {
          return KitapMenusu(
            kitap: kitapList[index],
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
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showDeleteBookDialog,
            tooltip: 'Kitap Sil',
            child: Icon(Icons.delete),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => UygulamaArayuzu(),
                ),
              );
            },
            child: Text('Uygulamaya Dön'),
          ),
        ],
      ),
    );
  }

}
