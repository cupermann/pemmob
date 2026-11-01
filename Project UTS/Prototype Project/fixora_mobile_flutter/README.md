# Fixora Mobile — Flutter/Dart (Android)

Konversi **9 layar Google Stitch** menjadi Flutter UI native, berbasis file ZIP Stitch yang diberikan. Ini adalah **prototype mahasiswa/pelapor**, bukan aplikasi Laravel yang sudah terintegrasi.

## Cara menjalankan di Android Studio (Windows)

1. Install Flutter SDK, Android Studio, Flutter/Dart plugin, dan Android SDK.
2. Ekstrak `Fixora_Mobile_Flutter_Android.zip` ke folder yang tidak terlalu panjang, misalnya `D:\Projects\fixora_mobile_flutter`.
3. **Jalankan `setup_windows.bat` sekali**. Ini melengkapi berkas Android/Gradle wrapper yang tidak bisa dibuat di lingkungan konversi dan mengunduh dependency Flutter.
   - Alternatif terminal di folder proyek: `flutter create --platforms=android --project-name fixora_mobile .` lalu `flutter pub get`.
4. Android Studio → **Open** → pilih folder yang berisi `pubspec.yaml` (bukan subfolder `android`).
5. Buka emulator Android atau sambungkan HP dengan USB debugging.
6. Pilih device, jalankan `lib/main.dart` dengan tombol **Run ▶**.

Perintah terminal untuk menjalankan:

```bash
flutter doctor
flutter create --platforms=android --project-name fixora_mobile .
flutter pub get
flutter run
```

`flutter create` tanpa `--overwrite` dipakai untuk membuat berkas Gradle wrapper yang mungkin belum ada; file Dart yang sudah dikonversi tidak perlu diganti.

> **Catatan validasi:** Flutter SDK tidak tersedia pada lingkungan konversi ini, sehingga `flutter analyze`, `flutter test`, dan build APK **belum dapat dijalankan di sini**. Validasi hasil build harus dilakukan di Android Studio/komputer dengan Flutter SDK.

## Akun demo

- Email: `muhammadyusuf@kampus.ac.id`
- Password: `Fixora123!`
- Atau pada halaman Login klik **Isi Akun Demo**.

Boleh daftar mahasiswa baru. Akun baru dan laporan baru **tersimpan dalam memori selama aplikasi masih berjalan**; akan kembali ke data demo setelah aplikasi ditutup sepenuhnya.

## Halaman & interaksi

| Halaman | Implementasi |
|---|---|
| Welcome | Navigasi Masuk dan Daftar |
| Login | Validasi email/password terhadap akun demo atau akun terdaftar di sesi itu |
| Registrasi | Validasi nama/NIM/email/password dan tambah akun dalam memori |
| Lupa Password | Simulasi verifikasi input & pesan keberhasilan (tidak mengirim email) |
| Dashboard | Banner responsive, CTA, shortcut, pengumuman, laporan terbaru, dokumentasi, panduan, scroll |
| Buat Laporan | Dropdown gedung→ruangan, kategori, validasi, pilihan prioritas, image_picker kamera/galeri, foto demo, simpan laporan lokal |
| Riwayat | Filter status, card laporan, navigasi ke detail, list otomatis diperbarui |
| Detail | Info lokasi, prioritas, foto, timeline, info teknisi, scroll |
| Profil | Identitas akun, statistik, bantuan, konfirmasi logout |

## Keterbatasan saat ini

- **BELUM** mengakses Laravel API atau MariaDB, tidak ada token Sanctum.
- **BELUM** ada dashboard admin dan teknisi dalam ZIP sumber; konversi ini mengikuti 9 layar **mahasiswa** yang tersedia.
- **BELUM** mengirim email pemulihan password, notifikasi, atau layanan WhatsApp.
- Model dan foto laporan demo digunakan untuk presentasi UI; jangan menggunakan akun demo sebagai autentikasi production.
- NIM baru belum diverifikasi terhadap SIAKAD kampus.

## Susunan proyek

```text
lib/
  main.dart
  core/theme.dart
  models/app_state.dart
  widgets/ui.dart
  screens/auth_screens.dart
  screens/student_screens.dart
assets/images/         Gambar contoh dari screenshot Stitch
android/               Struktur native Android (lengkapi dengan setup script)
design_reference/      Screenshot asli sembilan halaman Stitch
```

## Integrasi ke backend Fixora Laravel (tahap berikutnya)

1. Ganti `FixoraStore.login/register` dengan `/api/auth/login` dan `/api/auth/register` + Laravel Sanctum.
2. Buat endpoint `/api/me`, `/api/gedungs`, `/api/ruangans`, `/api/kategori-kerusakan`, `/api/laporan`, `/api/laporan/{id}` (nama final menyesuaikan route backend).
3. Tambahkan penyimpanan token aman (`flutter_secure_storage`) dan client HTTP (mis. `dio`).
4. Ganti `FixoraStore.reports/submit` agar berbasis API serta upload multipart.
5. Pastikan backend memfilter laporan menggunakan `user_id` milik mahasiswa yang sedang login.

## Desain

Warna dasar mengikuti `DESIGN.md` Stitch: `#0053DB` (biru), `#2563EB` (royal blue), `#FF7A2F` (oranye), `#FAF8FF` (latar). Seluruh antarmuka menggunakan widget Flutter, **bukan** WebView atau gambar layar penuh.
