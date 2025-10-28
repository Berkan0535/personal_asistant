# PlanPro (uygulama v2)

Bu klasör `main.dart` içeriğini bir Flutter uygulaması olarak çalıştırmak için gerekli temel dosyaları içerir.

Önemli: Bu projeyi çalıştırmak için makinenizde Flutter SDK ve Android Studio (veya uygun Android araç zinciri) yüklü olmalıdır.

Adımlar (Windows, PowerShell):

1. Flutter SDK kur
- Resmi: https://docs.flutter.dev/get-started/install/windows
- Örnek: SDK'yı `C:\src\flutter` içine çıkar.

2. PATH ekle (GUI veya PowerShell):
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```
Yeni bir PowerShell penceresi aç.

3. Android Studio kur ve en az bir AVD oluştur.

4. Proje köküne gel ve bağımlılıkları al:
```powershell
cd 'C:\Users\berka\Desktop\BİTİRME PROJESİ\uygulama v2'
flutter pub get
```

5. Emülatörü başlat (Android Studio'dan veya terminalden) ve çalıştır:
```powershell
flutter devices
flutter run
```

Eğer `flutter` komutu bulunamıyorsa: PATH doğru ayarlanmadı veya SDK kurulu değil.

Ben yardımcı olmaya hazırım: Flutter kurduktan sonra `flutter doctor -v` ve `flutter devices` çıktısını paylaşırsan ben inceleyip gereken düzeltmeleri yaparım.
