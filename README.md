# 📚 Kütüphane Otomasyonu

Modern ve kullanıcı dostu bir kütüphane yönetim sistemi. Flutter ile geliştirilmiş bu uygulama, kitap takibi, ödünç verme ve yönetim işlemlerini kolaylaştırır.

## ✨ Özellikler

### Kullanıcı Özellikleri
- 📖 **Kitap Listesi**: Tüm kitapları görüntüleme
- 🔍 **Arama**: Kitap adı, açıklama veya kod ile arama yapma
- 📱 **Modern UI**: Material Design 3 ile tasarlanmış kullanıcı arayüzü
- 🔄 **Pull to Refresh**: Liste yenileme
- 📸 **Görsel Desteği**: Network ve local görsel desteği

### Admin Özellikleri
- 🔐 **Güvenli Giriş**: E-posta ve şifre ile admin girişi
- ➕ **Kitap Ekleme**: Yeni kitap ekleme
- ✏️ **Kitap Düzenleme**: Mevcut kitapları düzenleme
- 🗑️ **Kitap Silme**: Kitapları silme
- 📊 **Yönetim Paneli**: Tüm kitapları yönetme

## 🛠️ Teknolojiler

- **Flutter**: Cross-platform mobil uygulama framework'ü
- **Dart**: Programlama dili
- **SQLite**: Yerel veritabanı (sqflite)
- **Provider**: State management
- **Material Design 3**: Modern UI tasarımı

## 📦 Kurulum

### Gereksinimler
- Flutter SDK (3.2.3 veya üzeri)
- Dart SDK
- Android Studio / VS Code
- Android SDK veya iOS SDK (platform bağımlı)

### Adımlar

1. **Projeyi klonlayın**
   ```bash
   git clone <repository-url>
   cd kutuphane_otomasyonu
   ```

2. **Bağımlılıkları yükleyin**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı çalıştırın**
   ```bash
   flutter run
   ```

## 🏗️ Proje Yapısı

```
lib/
├── core/
│   ├── constants/      # Uygulama sabitleri
│   └── theme/          # Tema ve stil tanımlamaları
├── model/              # Veri modelleri
├── pages/              # UI sayfaları
├── services/           # Servisler (veritabanı, API vb.)
└── main.dart          # Uygulama giriş noktası
```

## 🔑 Varsayılan Admin Bilgileri

**ÖNEMLİ**: Üretim ortamında mutlaka değiştirin!

- **E-posta**: `admin@kutuphane.com`
- **Şifre**: `admin123`

Bu bilgiler `lib/core/constants/app_constants.dart` dosyasında tanımlanmıştır.

## 📱 Kullanım

### Kullanıcı Modu
1. Uygulamayı açın
2. Ana sayfada tüm kitapları görüntüleyin
3. Arama ikonuna tıklayarak kitap arayın
4. Bir kitaba tıklayarak detaylarını görüntüleyin

### Admin Modu
1. Ana sayfada "Admin Girişi" butonuna tıklayın
2. Admin bilgileriyle giriş yapın
3. Yönetim panelinde:
   - ➕ butonu ile yeni kitap ekleyin
   - 🗑️ butonu ile kitap silin
   - Kitap kartına tıklayarak düzenleyin

## 🎨 Özelleştirme

### Tema Değiştirme
Tema ayarları `lib/core/theme/app_theme.dart` dosyasında bulunur.

### Sabitler
Uygulama sabitleri `lib/core/constants/app_constants.dart` dosyasında tanımlanmıştır.

## 🐛 Bilinen Sorunlar

- Şu anda sadece network URL'lerinden görsel yüklenebilir
- Local dosya yolu desteği henüz eklenmemiştir

## 🔮 Gelecek Özellikler

- [ ] Ödünç verme/alma sistemi
- [ ] Kullanıcı yönetimi
- [ ] Raporlama ve istatistikler
- [ ] Barcode/QR kod desteği
- [ ] Cloud senkronizasyonu
- [ ] Çoklu dil desteği
- [ ] Dark mode

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

## 👨‍💻 Geliştirici

Proje modernizasyonu ve güncellemeleri yapılmıştır.

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📞 İletişim

Sorularınız için issue açabilirsiniz.

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
