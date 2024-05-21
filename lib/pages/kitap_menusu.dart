import 'dart:io';
import 'package:flutter/material.dart';
import 'package:basit_arayuz/model/kitap.dart';


class KitapMenusu extends StatelessWidget {
  final KitapModel kitap;

  const KitapMenusu({Key? key, required this.kitap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(r"C:\Users\suleymangulter\Desktop\GM'24\kesilmiş.jpg")),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            kitap.kitapAdi!,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            kitap.kitapKodu! as String,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        kitap.kitapAciklamasi!,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
