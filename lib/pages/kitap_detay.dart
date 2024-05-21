import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basit_arayuz/model/kitap.dart';


import '../model/kitap_database_provider.dart';

class KitapDetay extends StatefulWidget {
  final String appBarTitle;
  final KitapModel kitap;

  KitapDetay(this.kitap, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return KitapDetayState(this.kitap, this.appBarTitle);
  }
}

class KitapDetayState extends State<KitapDetay> {
  BookDatabaseProvider helper = BookDatabaseProvider();
  String appBarTitle;
  KitapModel kitap;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  KitapDetayState(this.kitap, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = kitap.kitapAdi!;
    descriptionController.text = kitap.kitapAciklamasi!;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Title Text Field Changed');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Description Text Field Changed');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColorDark,
                          onPrimary: Theme.of(context).primaryColorLight,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColorDark,
                          onPrimary: Theme.of(context).primaryColorLight,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    kitap.kitapAdi = titleController.text;
  }

  void updateDescription() {
    kitap.kitapAciklamasi = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    int result = await helper.insertBook(kitap);

    if (result != 0) {
      _showAlertDialog('Status', 'Kitap Başarıyla Kaydedildi');
    } else {
      _showAlertDialog('Status', 'Kitap Kaydedilirken Hata Oluştu');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (kitap.kitapKodu == null) {
      _showAlertDialog('Status', 'Silinecek Kitap Bulunamadı');
      return;
    }

    int result = await helper.deleteBook(kitap.kitapKodu!);
    if (result != 0) {
      _showAlertDialog('Status', 'Kitap Başarıyla Silindi');
    } else {
      _showAlertDialog('Status', 'Kitap Silinirken Hata Oluştu');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}

