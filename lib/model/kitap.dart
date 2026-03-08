class KitapModel {
  final int? id;
  final String kitapAdi;
  final bool stoktaMi;
  final String? kitapKodu;
  final String? kitapResmi;
  final String? kitapAciklamasi;
  final DateTime? eklenmeTarihi;
  final DateTime? guncellemeTarihi;

  KitapModel({
    this.id,
    required this.kitapAdi,
    this.stoktaMi = true,
    this.kitapKodu,
    this.kitapResmi,
    this.kitapAciklamasi,
    this.eklenmeTarihi,
    this.guncellemeTarihi,
  });

  KitapModel copyWith({
    int? id,
    String? kitapAdi,
    bool? stoktaMi,
    String? kitapKodu,
    String? kitapResmi,
    String? kitapAciklamasi,
    DateTime? eklenmeTarihi,
    DateTime? guncellemeTarihi,
  }) {
    return KitapModel(
      id: id ?? this.id,
      kitapAdi: kitapAdi ?? this.kitapAdi,
      stoktaMi: stoktaMi ?? this.stoktaMi,
      kitapKodu: kitapKodu ?? this.kitapKodu,
      kitapResmi: kitapResmi ?? this.kitapResmi,
      kitapAciklamasi: kitapAciklamasi ?? this.kitapAciklamasi,
      eklenmeTarihi: eklenmeTarihi ?? this.eklenmeTarihi,
      guncellemeTarihi: guncellemeTarihi ?? this.guncellemeTarihi,
    );
  }

  factory KitapModel.fromMap(Map<String, dynamic> map) {
    return KitapModel(
      id: map['id'] as int?,
      kitapAdi: map['kitapAdi'] as String? ?? '',
      stoktaMi: (map['stoktaMi'] as int? ?? 1) == 1,
      kitapKodu: map['kitapKodu'] as String?,
      kitapResmi: map['kitapResmi'] as String?,
      kitapAciklamasi: map['kitapAciklamasi'] as String?,
      eklenmeTarihi: map['eklenmeTarihi'] != null
          ? DateTime.parse(map['eklenmeTarihi'] as String)
          : null,
      guncellemeTarihi: map['guncellemeTarihi'] != null
          ? DateTime.parse(map['guncellemeTarihi'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'kitapAdi': kitapAdi,
      'stoktaMi': stoktaMi ? 1 : 0,
      'kitapKodu': kitapKodu,
      'kitapResmi': kitapResmi,
      'kitapAciklamasi': kitapAciklamasi,
      if (eklenmeTarihi != null) 'eklenmeTarihi': eklenmeTarihi!.toIso8601String(),
      if (guncellemeTarihi != null) 'guncellemeTarihi': guncellemeTarihi!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'KitapModel(id: $id, kitapAdi: $kitapAdi, stoktaMi: $stoktaMi, kitapKodu: $kitapKodu)';
  }
}
