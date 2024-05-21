import 'package:basit_arayuz/pages/kitap_menusu_box_olusturucu.dart';
import 'package:flutter/material.dart';
import 'admin_giris.dart';


class UygulamaArayuzu extends StatelessWidget {
  const UygulamaArayuzu({Key? key});

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
      body: Uygulama_arayuzu(kitaplar: [],),
      backgroundColor: Colors.blue.shade500,
    );
  }
}
