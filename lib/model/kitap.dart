class KitapModel {
  String? kitapAdi;
  bool? stoktaMi;
  int? kitapKodu;
  String? kitapResmi;
  String? kitapAciklamasi;

  KitapModel({this.kitapAdi, this.stoktaMi, this.kitapKodu, this.kitapResmi, this.kitapAciklamasi});

  KitapModel.fromMap(Map<String, dynamic> map) {
    kitapAdi = map['kitapAdi'];
    stoktaMi = map['stoktaMi'];
    kitapKodu = map['kitapKodu'];
    kitapResmi = map['kitapResmi'];
    kitapAciklamasi = map['kitapAciklamasi'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['kitapAdi'] = kitapAdi;
    map['stoktaMi'] = stoktaMi;
    map['kitapKodu'] = kitapKodu;
    map['kitapResmi'] = kitapResmi;
    map['kitapAciklamasi'] = kitapAciklamasi;
    return map;
  }
}
