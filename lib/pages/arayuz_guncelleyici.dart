import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/kitap.dart';
import '../model/kitap_database_provider.dart';
import 'admin_giris.dart';
import 'kitap_menusu.dart';
import 'package:provider/provider.dart';

class UygulamaArayuzuGuncelleyici extends StatefulWidget {
  const UygulamaArayuzuGuncelleyici({Key? key});

  @override
  _UygulamaArayuzuState createState() => _UygulamaArayuzuState();
}

class _UygulamaArayuzuState extends State<UygulamaArayuzuGuncelleyici> {
  List<KitapModel> kitaplar = [];

  @override
  void initState() {
    super.initState();

    listenForKitapUpdates();
  }

  void listenForKitapUpdates() {
    final bookProvider = Provider.of<BookDatabaseProvider>(context, listen: false);
    setState(() {
      kitaplar = bookProvider.kitapListesi;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("UYGULAMA ARAYÜZÜ"),
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF1A237E),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const AdminGiris(),
                ),
              );
            },
            child: Icon(Icons.login),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: kitaplar.length,
        itemBuilder: (context, index) {
          return KitapMenusu(
            kitap: kitaplar[index],
          );
        },
      ),
      backgroundColor: Colors.blue.shade500,
    );
  }
}
