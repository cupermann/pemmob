# LAPORAN PRAKTIKUM FLUTTER FUNDAMENTAL — PERTEMUAN 6

## Tema, Routing dan Navigasi, serta Animasi

Dokumen ini menjelaskan pemahaman materi serta proses pengerjaan Praktikum Flutter Pertemuan 6 dari tahap persiapan, Bagian A sampai D, Latihan Mandiri Nomor 1 sampai 5, hingga penyelesaian tugas **Aplikasi Galeri/Katalog Interaktif**. Isi mengikuti materi dan instruksi Modul Praktikum Flutter Fundamental Pertemuan 6. Penjelasan implementasi latihan mandiri dan tugas disesuaikan dengan kode yang dibuat selama praktikum, karena modul menyampaikan sebagian bagian tersebut sebagai instruksi, bukan kode lengkap.

## 1. Tujuan Praktikum

Setelah mengikuti pertemuan ini, saya memahami cara membuat aplikasi Flutter dengan tema terang dan gelap, mengubah warna tema, menggunakan named routes untuk berpindah halaman dan mengirim data, menerapkan navigasi tab bawah, serta membuat beberapa jenis animasi. Saya juga mempraktikkan penyimpanan pilihan tema secara lokal agar tetap tersedia saat aplikasi dibuka kembali.

Materi inti yang dipelajari meliputi:

- `ThemeData`, `ThemeMode`, `ValueNotifier`, `ListenableBuilder`, dan `Theme.of(context)`.
- `Navigator.pushNamed`, argumen rute, `onGenerateRoute`, dan `Hero`.
- `AnimatedContainer`, `AnimatedSwitcher`, dan `AnimationController`.
- `NavigationBar` dan `IndexedStack`.
- Latihan lanjutan berupa `shared_preferences`, `Drawer`, `PageRouteBuilder` dengan `FadeTransition`, `onUnknownRoute`, serta `AnimatedOpacity`.

## 2. Persiapan Praktikum

Praktikum menggunakan Flutter SDK, Android Studio, dan emulator Android. Berdasarkan instruksi modul, proyek dasar dibuat menggunakan perintah:

```bash
flutter create praktikum_6
cd praktikum_6
```

Pada Bagian A–D tidak diperlukan package tambahan. Package `shared_preferences` baru digunakan pada Latihan Mandiri Nomor 1 dan dipertahankan dalam tugas akhir.

```bash
flutter pub add shared_preferences
flutter pub get
```

Selama pengerjaan, setiap tahap ditulis sebagai satu berkas Dart yang dapat dijalankan secara terpisah. Penamaan berkas latihan merupakan cara mengorganisasi pekerjaan, bukan persyaratan khusus dari modul.

## 3. Proses Pengerjaan Bagian A–D

### Bagian A — Tema Terang/Gelap dan Warna Tema

Pada bagian pertama saya membuat pengaturan tampilan menggunakan `ThemeData`. Tema terang dan gelap ditentukan melalui parameter `theme` dan `darkTheme` pada `MaterialApp`, sedangkan `ThemeMode` menentukan mode yang sedang aktif. Dua `ValueNotifier` digunakan untuk menyimpan pilihan mode dan warna. `ListenableBuilder` membuat aplikasi memperbarui tampilan ketika salah satu nilai tersebut berubah.

Modul menyediakan empat warna pilihan, yaitu Indigo, Teal, Deep Orange, dan Pink. Pengguna memilih warna melalui lingkaran berwarna dan mengaktifkan mode gelap melalui `SwitchListTile`. Saya memahami bahwa `Theme.of(context)` memungkinkan gaya teks mengikuti tema aplikasi secara otomatis.

**Hasil:** Saklar mode gelap dan pilihan warna mengubah tampilan aplikasi secara langsung tanpa perlu memulai ulang aplikasi.

### Bagian B — Named Routes, Argumen, dan Hero

Setelah pengaturan tema berhasil, saya membuat model `Item` yang memuat nama, ikon, dan warna. Modul menyediakan item Flutter, Musik, Kamera, dan Peta. Keempat item ditampilkan di `BerandaTab` menggunakan `ListView.builder` dan `ListTile`.

Saat suatu item ditekan, aplikasi menjalankan `Navigator.pushNamed(context, '/detail', arguments: item)`. Rute `/detail` ditangani di `onGenerateRoute` agar `DetailPage` menerima item yang dipilih. Widget `Hero` dengan tag yang sama dipasang pada ikon di halaman daftar dan halaman detail sehingga ikon tampak berpindah dan membesar secara halus.

**Hasil:** Setiap item membuka halaman detail yang sesuai, animasi Hero berjalan, dan tombol kembali membawa pengguna ke halaman daftar. Pada tahap ini halaman Pengaturan sementara belum ditampilkan, sesuai urutan modul.

### Bagian C — Animasi

Pada bagian animasi saya menambahkan `AnimasiTab` yang berisi tiga percobaan:

1. **`AnimatedContainer`** mengubah lebar, warna, dan sudut kotak ketika tombol **Ubah bentuk** ditekan. Perubahan berlangsung selama 500 milidetik.
2. **`AnimatedSwitcher`** mengubah tampilan angka setiap tombol **Tambah** ditekan. `ValueKey(_hitung)` membedakan widget angka lama dan baru, sedangkan `ScaleTransition` menghasilkan efek membesar.
3. **`AnimationController`** menggerakkan ikon roda gigi menggunakan `RotationTransition`. Ikon berputar dalam siklus dua detik dan dapat dihentikan atau dijalankan kembali.

Untuk animasi eksplisit, state menggunakan `SingleTickerProviderStateMixin` sebagai penyedia `vsync`. `AnimationController` dibuat pada `initState()` dan dibersihkan dengan `dispose()`.

**Hasil:** Ketiga animasi berjalan sesuai fungsi masing-masing. Sesuai checkpoint modul, halaman awal sementara menampilkan `AnimasiTab` agar animasi dapat diperiksa sebelum digabungkan ke navigasi bawah.

### Bagian D — Navigasi Tab Bawah

Selanjutnya saya membuat `ShellPage` yang menggabungkan tiga tab: **Beranda**, **Animasi**, dan **Pengaturan**. `NavigationBar` menyediakan pilihan tab di bagian bawah aplikasi. Nilai `_index` menyimpan tab aktif, sedangkan `IndexedStack` menampilkan tab tersebut dan menjaga state tab lainnya.

Saya menguji perpindahan tab dengan mengubah angka di `AnimatedSwitcher`, berpindah ke tab lain, lalu kembali ke tab Animasi. Angka tetap dipertahankan karena tab tidak dibuat ulang setiap kali berpindah.

**Hasil:** Ketiga tab dapat diakses, halaman detail dengan Hero tetap berfungsi, demonstrasi animasi tetap tersedia, serta pilihan tema berlaku untuk keseluruhan aplikasi.

## 4. Proses Pengerjaan Latihan Mandiri

### Latihan Mandiri Nomor 1 — Menyimpan Tema

Saya menggunakan `shared_preferences` untuk menyimpan mode gelap sebagai nilai `bool` dan warna pilihan sebagai nilai integer. Fungsi `main()` diubah menjadi `async`, kemudian memanggil `WidgetsFlutterBinding.ensureInitialized()` dan memuat preferensi sebelum menjalankan `runApp()`.

Ketika saklar atau warna dipilih, aplikasi memperbarui `ValueNotifier` dan menyimpan pengaturan. Saat aplikasi dijalankan kembali, pengaturan yang tersimpan dibaca lagi.

**Pengujian:** Mengaktifkan mode gelap dan memilih Pink, menutup aplikasi, lalu membukanya kembali untuk memastikan pilihan tetap digunakan.

### Latihan Mandiri Nomor 2 — Drawer

Saya menambahkan `Drawer` pada `ShellPage` dengan tiga menu: Beranda, Animasi, dan Pengaturan. Setiap menu mengubah `_index` sesuai halaman yang dipilih, kemudian menutup Drawer menggunakan `Navigator.pop(context)`.

**Pengujian:** Membuka Drawer dari AppBar, berpindah tab melalui menu samping, lalu memastikan `NavigationBar` bawah tetap dapat digunakan.

### Latihan Mandiri Nomor 3 — FadeTransition

Saya mengganti `MaterialPageRoute` untuk halaman detail menjadi `PageRouteBuilder` di `onGenerateRoute`. Dalam `transitionsBuilder`, `FadeTransition` menggunakan nilai `animation` sebagai `opacity` sehingga halaman detail muncul dan menghilang dengan efek memudar.

**Pengujian:** Membuka dan menutup detail Flutter, Musik, Kamera, dan Peta. Animasi Hero pada ikon tetap dipertahankan.

### Latihan Mandiri Nomor 4 — Halaman 404

Saya menambahkan `onUnknownRoute` pada `MaterialApp` untuk menampilkan `Scaffold` sederhana dengan teks **404 - Halaman tidak ditemukan** jika aplikasi membuka rute yang tidak terdaftar.

**Pengujian:** Untuk sementara, tujuan `Navigator.pushNamed` diganti menjadi `/halaman-tidak-ada`. Setelah tampilan 404 muncul, tujuan navigasi dikembalikan menjadi `/detail` agar perilaku aplikasi semula tetap terjaga.

### Latihan Mandiri Nomor 5 — AnimatedOpacity

Saya menambahkan demonstrasi keempat pada `AnimasiTab`, yaitu `AnimatedOpacity` yang membungkus sebuah `Card`. Variabel `_terlihat` menentukan nilai `opacity` antara `1.0` dan `0.0`. Tombol **Sembunyikan** dan **Tampilkan** mengubah nilainya menggunakan `setState()`.

**Pengujian:** Menekan Sembunyikan membuat kartu memudar, sedangkan menekan Tampilkan membuat kartu muncul kembali. Saya juga memeriksa bahwa tab Animasi tetap mempertahankan state ketika berpindah tab.

## 5. Proses Pembuatan Tugas Akhir — Aplikasi Galeri/Katalog Interaktif

Pada Bagian 6 modul, tugasnya adalah membuat aplikasi Galeri/Katalog Interaktif dengan tema bebas. Saya memilih **Katalog Interaktif** yang tetap menggunakan empat contoh item dari modul: Flutter, Musik, Kamera, dan Peta. Seluruh kode tugas dibuat dalam satu file `lib/tugas6.dart`.

### 5.1 Menentukan Susunan Tab

Aplikasi tugas akhir memiliki tiga tab menggunakan `NavigationBar`:

- **Beranda**: menampilkan judul Katalog Interaktif dan demonstrasi animasi.
- **Katalog**: menampilkan daftar empat item yang dapat dibuka ke halaman detail.
- **Pengaturan**: menyediakan saklar mode terang/gelap serta empat pilihan warna tema.

`IndexedStack` digunakan untuk mempertahankan keadaan tab saat pengguna berpindah menu.

### 5.2 Membuat Katalog dan Halaman Detail

Data katalog disimpan dalam model `Item` sederhana berisi nama dan ikon. Item ditampilkan dengan `ListView.builder`. Ketika item ditekan, `Navigator.pushNamed` mengirim argumen ke rute `/detail`. Halaman tujuan menggunakan `DetailPage` untuk menampilkan nama, ikon berukuran lebih besar, dan teks detail. Widget `Hero` dipakai pada ikon daftar dan ikon detail dengan tag yang sama.

### 5.3 Menerapkan Dua Jenis Animasi

Untuk memenuhi syarat animasi implisit dan eksplisit, tab Beranda memuat:

- `AnimatedContainer`: kotak berubah bentuk, ukuran, dan warna setelah tombol ditekan.
- `AnimationController` bersama `RotationTransition`: ikon roda gigi berputar dan dapat dihentikan atau dijalankan kembali.

Kedua animasi tersebut menggunakan mekanisme yang sudah dipelajari dalam Bagian C.

### 5.4 Menerapkan Pengaturan Tema

Tema dibuat melalui `ThemeData`, `ThemeMode`, dan `colorSchemeSeed`. Aplikasi menyediakan mode terang dan gelap, serta empat pilihan warna: Indigo, Teal, Deep Orange, dan Pink. Untuk warna komponen dan gaya teks pada bagian utama tugas, saya memakai `Theme.of(context).colorScheme` dan `Theme.of(context).textTheme` agar mengikuti tema aktif.

### 5.5 Menyimpan Pengaturan

Pilihan mode dan warna disimpan menggunakan `shared_preferences`. Ketika aplikasi dimulai, data dibaca lebih dahulu melalui fungsi pemuatan preferensi. Dengan demikian, pilihan tema dapat dipertahankan setelah aplikasi ditutup dan dibuka kembali.

### 5.6 Menyelesaikan Implementasi

Setelah tab, routing, Hero, animasi, dan pengaturan tema digabungkan, hasil tugas dijalankan melalui file `tugas6.dart`. Kode tugas hanya menggunakan komponen yang relevan dengan ketentuan Bagian 6; tidak semua fitur Latihan Mandiri 1–5 harus ditampilkan lagi dalam tugas akhir.

## 6. Cara Menjalankan Aplikasi Akhir

Buka terminal pada direktori proyek, lalu pastikan dependensi tersedia:

```bash
flutter pub get
```

Jalankan tugas akhir pada emulator Android:

```bash
flutter run -t lib/tugas6.dart
```

Jika menggunakan Android Studio, buka `tugas6.dart`, pilih emulator yang aktif, lalu jalankan file tersebut.

## 7. Pengujian dan Hasil yang Diharapkan

Pengujian dilakukan untuk memastikan seluruh persyaratan tugas terpenuhi:

| Pengujian | Hasil yang diharapkan |
| --- | --- |
| Navigasi bawah | Tiga tab Beranda, Katalog, dan Pengaturan dapat dibuka. |
| Daftar katalog | Empat item muncul dan dapat ditekan. |
| Named routes | Item yang dipilih dikirim ke halaman `/detail`. |
| Hero | Ikon beranimasi saat berpindah ke detail dan saat kembali. |
| AnimatedContainer | Kotak berubah ukuran, bentuk, dan warna secara halus. |
| AnimationController | Ikon berputar serta dapat dihentikan dan dijalankan kembali. |
| Mode tema | Tema terang dan gelap dapat diubah. |
| Warna tema | Indigo, Teal, Deep Orange, dan Pink dapat dipilih. |
| Penyimpanan tema | Pilihan tema dimuat kembali setelah aplikasi ditutup dan dibuka ulang. |
| Konsistensi tema | Warna komponen dan gaya teks mengikuti tema aktif. |

*Catatan:* Tabel di atas menjelaskan hasil yang harus diperiksa. README ini mendokumentasikan proses dan kriteria pengujian; bukti hasil di emulator perlu ditunjukkan melalui screenshot yang dikumpulkan.

## 8. Bukti Pengumpulan

Modul meminta tiga screenshot dan berkas kode atau tautan repositori. Bukti yang perlu disiapkan:

1. **Mode terang** — screenshot aplikasi saat mode terang aktif, misalnya pada tab Pengaturan.
2. **Mode gelap** — screenshot aplikasi saat mode gelap aktif.
3. **Halaman detail** — screenshot halaman detail salah satu item, misalnya Flutter.
4. **Kode tugas** — file `tugas6.dart` atau tautan repositori.

Nama file screenshot dapat menggunakan `01_mode_terang.png`, `02_mode_gelap.png`, dan `03_halaman_detail.png`. Nama tersebut hanya usulan penataan berkas, bukan aturan khusus modul.

## 9. Pemahaman yang Diperoleh

Dari praktikum ini saya memahami bahwa tema yang dikelola secara terpusat membuat tampilan aplikasi lebih konsisten dan lebih mudah disesuaikan. Dengan `Theme.of(context)`, tampilan komponen mengikuti perubahan tema tanpa perlu menentukan setiap warna atau gaya teks secara terpisah.

Saya juga memahami perbedaan antara berpindah halaman melalui `Navigator` dan berpindah tab melalui `IndexedStack`. `Navigator` membuka halaman baru, sedangkan `IndexedStack` mengganti tab yang terlihat sambil mempertahankan state tab lainnya. Pada `Hero`, tag yang sama dibutuhkan untuk menghubungkan elemen yang berpindah di antara dua halaman.

Dalam materi animasi, `AnimatedContainer`, `AnimatedSwitcher`, dan `AnimatedOpacity` menunjukkan bagaimana perubahan tampilan sederhana dapat dianimasikan secara implisit. Sementara itu, `AnimationController` digunakan saat diperlukan kendali lebih langsung atas animasi, seperti mengulang atau menghentikan putaran. Controller perlu dibersihkan melalui `dispose()` agar sumber daya yang digunakannya dilepaskan ketika widget selesai dipakai.

Melalui latihan lanjutan, saya memahami bahwa data pengaturan kecil dapat disimpan menggunakan `shared_preferences`, bahwa `Drawer` dapat menjadi alternatif navigasi, dan bahwa routing dapat dikembangkan dengan transisi khusus serta penanganan rute tidak dikenal.

## 10. Kesimpulan

Proses praktikum dimulai dari membuat tema aplikasi, membangun navigasi halaman dan animasi Hero, mempraktikkan animasi implisit dan eksplisit, lalu menggabungkan semua halaman dalam navigasi tab bawah. Tahap berikutnya mencakup lima latihan mandiri: penyimpanan tema, Drawer, FadeTransition, halaman 404, dan AnimatedOpacity. Setelah itu, materi diterapkan ke tugas akhir berupa **Aplikasi Katalog Interaktif** dengan tiga tab, halaman detail, dua jenis animasi, dan tema yang dapat diubah serta disimpan.

Pengerjaan ini membantu saya memahami hubungan antara pengaturan tema, navigasi, state, dan animasi dalam satu aplikasi Flutter. Hasil akhir berupa implementasi kode yang perlu diuji dan didokumentasikan melalui tiga screenshot sesuai ketentuan pengumpulan modul.

---

**Sumber utama:** *Modul Praktikum Flutter Fundamental — Pertemuan 6: Tema, Routing dan Navigasi, serta Animasi*, halaman 1–8. Tidak menggunakan materi pembelajaran dari luar modul sebagai dasar pembahasan.

> **Nama:** Muhammad Yusuf Bagus Syafaat  
> **NIM:** 20240801041