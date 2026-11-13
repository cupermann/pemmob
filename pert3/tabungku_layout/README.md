# TabungKu Layout

> **Nama:** Muhammad Yusuf Bagus Syafaat  
> **NIM:** 20240801041

**TabungKu Layout** adalah aplikasi Flutter sederhana untuk menampilkan ringkasan tabungan pribadi. Proyek ini dibuat sebagai latihan penyusunan antarmuka (*layout*) menggunakan widget dasar Flutter yang dipelajari pada Pertemuan 1 dan 2.

Aplikasi berfokus pada **tampilan statis (pure layout)**. Ikon **Menabung**, **Tarik**, dan **Riwayat** merupakan kategori visual dan belum menjalankan transaksi atau membuka halaman lain. Seluruh data tabungan dan transaksi ditulis langsung di dalam `lib/main.dart` (*hard-code*).

## Tampilan dan fitur

- **Ringkasan tabungan:** kartu berisi nama tabungan, saldo saat ini, dan target tabungan.
- **Kategori:** tiga ikon dalam satu baris untuk Menabung, Tarik, dan Riwayat.
- **Transaksi terbaru:** daftar berisi tiga transaksi, masing-masing menampilkan judul, tanggal, dan nominal.
- **Layout adaptif:** memanfaatkan `Expanded` agar isi `Row` menyesuaikan lebar layar, serta `ListView.builder` agar halaman dapat di-scroll pada layar yang lebih pendek.

## Teknologi

- Flutter dan Dart
- Widget bawaan Flutter, antara lain `MaterialApp`, `Scaffold`, `AppBar`, `Card`, `Padding`, `Row`, `Column`, `Expanded`, `SizedBox`, `Icon`, `Text`, `ListView.builder`, dan `ListTile`
- **Tanpa paket pihak ketiga** dan tanpa GetX/Provider

## Struktur proyek

```text
tabungku_layout/
├── lib/
│   └── main.dart       # Tampilan utama dan data transaksi statis
├── android/            # Konfigurasi platform Android
├── ios/                # Konfigurasi platform iOS
├── pubspec.yaml        # Konfigurasi proyek Flutter
└── README.md           # Dokumentasi proyek
```

## Persyaratan

1. Flutter SDK sudah terpasang dan dapat dijalankan melalui terminal.
2. Android Studio (atau editor yang mendukung Flutter/Dart).
3. Emulator Android atau perangkat Android fisik yang telah terhubung.

Periksa instalasi Flutter dengan:

```bash
flutter doctor
```

## Cara menjalankan aplikasi

1. Buka folder proyek `tabungku_layout` di Android Studio.
2. Pastikan emulator atau perangkat Android sudah aktif.
3. Buka terminal di direktori utama proyek dan jalankan:

   ```bash
   flutter pub get
   flutter run
   ```

4. Jika ada lebih dari satu perangkat, lihat daftar perangkat dengan `flutter devices`, kemudian pilih perangkat melalui dropdown di Android Studio atau jalankan `flutter run -d <device-id>`.
5. Alternatifnya, buka `lib/main.dart` dan tekan tombol **Run** di Android Studio.

> `flutter pub get` menyiapkan dependensi proyek yang tercatat pada `pubspec.yaml`. Perintah ini **tidak berarti** aplikasi memakai paket pihak ketiga; pada proyek ini tidak ada dependensi tambahan untuk fitur TabungKu.

## Pengujian tampilan

Layout diuji secara visual pada dua ukuran emulator Android:

| Perangkat | Tujuan pengujian |
| --- | --- |
| Pixel 8 (smartphone) | Memeriksa kartu ringkasan, ikon kategori, dan daftar transaksi pada layar ponsel. |
| Small Tablet (tablet) | Memeriksa susunan layout pada layar lebih lebar dan memastikan daftar tetap dapat di-scroll. |

**Dokumentasi:** sertakan tangkapan layar hasil pengujian smartphone dan tablet saat pengumpulan tugas. Pastikan tidak muncul indikator *RenderFlex overflowed*.
