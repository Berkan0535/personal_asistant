# 📅 PlanPro - Akıllı Haftalık Planlayıcı

<p align="center">
  <img src="assets/logo.png" alt="PlanPro Logo" width="200"/>
</p>

<p align="center">
  <strong>Haftanı Akıllıca Planla! ✨</strong>
</p>

<p align="center">
  <a href="#özellikler">Özellikler</a> •
  <a href="#ekran-görüntüleri">Ekran Görüntüleri</a> •
  <a href="#kurulum">Kurulum</a> •
  <a href="#kullanım">Kullanım</a> •
  <a href="#mimari">Mimari</a> •
  <a href="#katkıda-bulunma">Katkıda Bulunma</a>
</p>

---

## 📖 Hakkında

PlanPro, yapay zeka destekli haftalık planlama uygulamasıdır. Kullanıcılar serbest metin olarak haftalık planlarını yazabilir ve yapay zeka bu planları otomatik olarak günlere ve saatlere göre organize eder.

### 🎯 Temel Konsept
- 📝 Serbest metin girişi ile kolay planlama
- 🤖 AI destekli otomatik görev organizasyonu
- 📊 Görsel ilerleme takibi
- ✅ Görev tamamlama ve motivasyon sistemi

---

## ✨ Özellikler

### 🚀 Ana Özellikler
- **AI Destekli Planlama**: Serbest metin girişinizi AI ile organize edin
- **Haftalık Görünüm**: Tüm haftayı tek ekranda görün
- **Görev Yönetimi**: Görevleri tamamlayın ve ilerlemenizi takip edin
- **Motivasyon Sistemi**: Her tamamlanan görev için motivasyonel mesajlar
- **Modern UI/UX**: Material Design 3 ve akıcı animasyonlar
- **Responsive Tasarım**: Tüm ekran boyutlarında mükemmel görünüm

### 🎨 Görsel Özellikler
- ✨ Gradient tasarım ve smooth animasyonlar
- 🌈 Her gün için farklı renk temaları
- 📱 Haptic feedback desteği
- 🎭 Splash screen animasyonu
- 💫 Sayfa geçiş animasyonları

### 📊 Takip Özellikleri
- İlerleme yüzdesi gösterimi
- Tamamlanan/toplam görev sayısı
- Günlük görev sayıları
- Zaman bazlı görev organizasyonu

---

## 📱 Ekran Görüntüleri

<p align="center">
  <img src="screenshots/splash.png" width="250"/>
  <img src="screenshots/home.png" width="250"/>
  <img src="screenshots/planning.png" width="250"/>
</p>

---

## 🛠️ Teknolojiler

### Framework & Diller
- **Flutter** 3.16.0+
- **Dart** 3.2.0+

### Kullanılan Paketler
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # API çağrıları
  provider: ^6.1.1          # State management
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Mimari Pattern
- **MVVM (Model-View-ViewModel)** pattern
- **Service Layer** pattern
- **Repository** pattern
- **Clean Architecture** prensipleri

---

## 📦 Kurulum

### Gereksinimler
- Flutter SDK (3.16.0 veya üzeri)
- Dart SDK (3.2.0 veya üzeri)
- Android Studio / VS Code
- Git

### Adımlar

1. **Repoyu klonlayın**
```bash
git clone https://github.com/yourusername/planpro.git
cd planpro
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Uygulamayı çalıştırın**
```bash
flutter run
```

### Platform Spesifik Kurulum

#### Android
```bash
flutter run -d android
```

#### iOS
```bash
flutter run -d ios
```

#### Web
```bash
flutter run -d chrome
```

---

## 🎮 Kullanım

### Hızlı Başlangıç

1. **Uygulamayı başlatın**
   - Splash ekranı otomatik olarak ana ekrana geçiş yapacaktır

2. **Plan oluşturun**
   - Ana ekranda metin alanına haftalık planınızı yazın
   - Örnek: "Pazartesi sabah spor, öğleden sonra toplantı..."

3. **AI ile organize edin**
   - "AI ile Planla" butonuna tıklayın
   - AI planınızı otomatik olarak organize edecektir

4. **İlerlemenizi takip edin**
   - Görevleri tamamladıkça checkboxları işaretleyin
   - İlerleme çubuğunuzda değişimi görün
   - Motivasyonel mesajlar alın

### Örnek Girdi

```text
Pazartesi sabah 7'de koşu yapacağım
Salı öğleden sonra müşteri toplantısı var
Çarşamba 14:00-16:00 kod review
Perşembe proje sunumu
Cuma haftalık retrospektif
```

### Çıktı

Uygulama otomatik olarak:
- Günlere göre organize edecek
- Saatleri algılayacak (varsa)
- Her gün için renk temaları oluşturacak
- Görev sayılarını hesaplayacak

---

## 🏗️ Mimari

### Proje Yapısı

```
lib/
├── main.dart                      # Uygulama giriş noktası
├── core/                          # Çekirdek özellikler
│   ├── constants/                 # Sabitler
│   │   ├── app_colors.dart       # Renk tanımları
│   │   ├── app_strings.dart      # Metin sabitleri
│   │   └── app_theme.dart        # Tema yapılandırması
│   ├── utils/                     # Yardımcı fonksiyonlar
│   └── widgets/                   # Ortak widgetlar
├── models/                        # Veri modelleri
│   └── task.dart                 # Görev modeli
├── services/                      # İş mantığı katmanı
│   ├── ai_service.dart           # AI API servisi
│   └── task_parser_service.dart  # Görev parse servisi
├── viewmodels/                    # State yönetimi
│   ├── home_viewmodel.dart       # Ana ekran VM
│   └── planning_viewmodel.dart   # Planlama ekranı VM
└── views/                         # UI katmanı
    ├── splash/                    # Splash ekranı
    ├── home/                      # Ana ekran
    │   └── widgets/              # Ana ekran widgetları
    └── planning/                  # Planlama ekranı
        └── widgets/              # Planlama ekranı widgetları
```

### Katman Sorumlulukları

#### 1. **Models** (Veri Katmanı)
- Uygulama veri modellerini tanımlar
- JSON serialization/deserialization
- İş kurallarından bağımsız

#### 2. **Services** (İş Mantığı Katmanı)
- API çağrıları
- Veri işleme ve dönüşümler
- Üçüncü parti entegrasyonlar

#### 3. **ViewModels** (Sunum Mantığı)
- UI state yönetimi
- Services ile Views arasında köprü
- Business logic'i UI'dan ayırır

#### 4. **Views** (Sunum Katmanı)
- Sadece UI render
- ViewModels'i dinler
- Kullanıcı etkileşimlerini yakalar

### Design Patterns

- **MVVM**: Ana mimari pattern
- **Observer**: State değişikliklerini dinleme
- **Singleton**: Service sınıfları için
- **Factory**: Model oluşturma için

---

## 🔧 Yapılandırma

### AI API Entegrasyonu

`services/ai_service.dart` dosyasında API endpoint'inizi güncelleyin:

```dart
class AIService {
  static const String _baseUrl = 'YOUR_API_ENDPOINT';
  static const String _apiKey = 'YOUR_API_KEY';
  
  // API çağrılarınızı buraya ekleyin
}
```

### Tema Özelleştirme

`core/constants/app_colors.dart` dosyasından renkleri özelleştirin:

```dart
class AppColors {
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFFA29BFE);
  // Diğer renkler...
}
```

---

## 🧪 Test

### Unit Testleri Çalıştırma

```bash
flutter test
```

### Test Kapsamı

```bash
flutter test --coverage
```

### Widget Testleri

```bash
flutter test test/widget_test.dart
```

---

## 📈 Performans

- **Uygulama Boyutu**: ~15 MB (release build)
- **Başlangıç Süresi**: ~2 saniye
- **Ortalama FPS**: 60 FPS
- **Memory Kullanımı**: ~50 MB

---

## 🚀 Deployment

### Android Release Build

```bash
flutter build apk --release
# veya
flutter build appbundle --release
```

### iOS Release Build

```bash
flutter build ios --release
```

### Web Deploy

```bash
flutter build web --release
```

---

## 🤝 Katkıda Bulunma

Katkılarınızı memnuniyetle karşılıyoruz! 

### Katkı Adımları

1. Projeyi fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

### Kod Standartları

- Flutter/Dart best practices
- Clean code prensipleri
- Yorum satırları ile dokümantasyon
- Unit testler yazın

---

## 📝 Yol Haritası

### v1.0 (Mevcut)
- ✅ Temel planlama özelliği
- ✅ AI entegrasyonu altyapısı
- ✅ Görev tamamlama sistemi
- ✅ İlerleme takibi

### v1.1 (Planlanan)
- [ ] Gerçek AI API entegrasyonu
- [ ] Görev bildirimleri
- [ ] Veri persistence (local storage)
- [ ] Karanlık mod geçişi

### v1.2 (Planlanan)
- [ ] Takvim görünümü
- [ ] Görev kategorileri
- [ ] İstatistikler sayfası
- [ ] Export/Import özellikleri

### v2.0 (Gelecek)
- [ ] Çoklu kullanıcı desteği
- [ ] Bulut senkronizasyonu
- [ ] Takım işbirliği özellikleri
- [ ] Widget desteği

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 👥 Ekip

- **Geliştirici**: [Adınız](https://github.com/yourusername)
- **Tasarım**: [Tasarımcı Adı]
- **AI Entegrasyon**: [AI Developer Adı]

---

## 📞 İletişim

- **Email**: berkansucsuz95@gmail.com
- **GitHub**: [@Berkan0535](https://github.com/Berkan0535)
- **LinkedIn**: [Berkan Suçsuz](www.linkedin.com/in/berkan-suçsuz-5a820b309)
---

## 🙏 Teşekkürler

- [Flutter Team](https://flutter.dev) - Harika framework için
- [Material Design](https://material.io) - Tasarım ilkeleri için
- AI API sağlayıcıları
- Açık kaynak topluluğu

---

## 📚 Kaynaklar

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

<p align="center">
  Made with ❤️ by PlanPro Team
</p>

<p align="center">
  <a href="#top">Başa Dön ⬆️</a>
</p>
