import 'package:flutter/cupertino.dart';

import '../model/kitap.dart';
import 'kitap_menusu.dart';

class Uygulama_arayuzu extends StatelessWidget {
  final List<KitapModel> kitaplar;

  const Uygulama_arayuzu({Key? key, required this.kitaplar});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kitaplar.length,
      itemBuilder: (context, index) {
        return KitapMenusu(
          kitap: kitaplar[index],
        );
      },
    );
  }
}
