# LAPORAN PRAKTIKUM FLUTTER FUNDAMENTAL — PERTEMUAN 5

## Penyimpanan Lokal dengan SharedPreferences dan SQLite

Dokumen ini menjelaskan pemahaman materi serta proses pengerjaan Praktikum Flutter Fundamental Pertemuan 5, mulai dari Bagian A sampai Bagian D, dilanjutkan Latihan Mandiri Nomor 1–4, dan diakhiri dengan Tugas Aplikasi Pencatat Pengeluaran. Pembahasan mengacu pada modul **Pertemuan 5: Penyimpanan Lokal (SharedPreferences dan SQLite)** dan implementasi kode yang dikerjakan selama praktikum.

## 1. Tujuan dan Pemahaman Materi

Pada pertemuan ini saya mempelajari cara menyimpan data secara lokal agar tetap tersedia meskipun aplikasi ditutup dan dibuka kembali. Sebelumnya, data yang hanya disimpan pada variabel atau `State` akan hilang ketika aplikasi berakhir. Dengan penyimpanan lokal, aplikasi dapat mempertahankan pengaturan dan catatan pengguna.

Modul memperkenalkan tiga pilihan penyimpanan. **SharedPreferences** digunakan untuk data sederhana berbentuk pasangan kunci dan nilai, seperti nama, mode gelap, dan jumlah aplikasi dibuka. **SQLite** digunakan untuk data yang lebih terstruktur, seperti daftar catatan dan pengeluaran. Penyimpanan **berkas** juga diperkenalkan secara teori untuk dokumen atau gambar, tetapi tidak menjadi fokus implementasi praktikum ini.

Konsep penting lainnya adalah operasi **CRUD**: *Create* untuk menambah data, *Read* untuk membaca data, *Update* untuk mengubah data, dan *Delete* untuk menghapus data. Pada `sqflite`, operasi tersebut dilakukan menggunakan `db.insert()`, `db.query()`, `db.update()`, dan `db.delete()`.

Modul juga menekankan penggunaan placeholder SQL, seperti `where: 'id = ?'` dan `whereArgs: [id]`, agar nilai parameter tidak disambungkan langsung ke teks query.

## 2. Persiapan Praktikum

Praktikum dijalankan menggunakan Flutter SDK, Android Studio, dan emulator Android. Pada modul, contoh awal proyek dibuat dengan perintah:

```bash
flutter create praktikum_5
```

Dalam pengerjaan, saya menggunakan proyek Flutter yang menampung file Dart terpisah untuk setiap tahap. Pemisahan ini dilakukan agar hasil Bagian A, B, C, D, dan masing-masing latihan mandiri bisa diperiksa sendiri tanpa mengganti pekerjaan sebelumnya. Setiap tahap tetap berisi kode yang diperlukan agar dapat dijalankan secara mandiri.

Paket yang digunakan sepanjang praktikum dipasang dengan perintah berikut:

```bash
flutter pub add shared_preferences
flutter pub add sqflite path
```

`shared_preferences` digunakan untuk menyimpan pengaturan, `sqflite` digunakan untuk mengakses SQLite, dan `path` digunakan untuk menyusun lokasi file database.

### Struktur file pengerjaan

```text
praktikum5/
└── lib/
    ├── bagian_a.dart
    ├── bagian_b.dart
    ├── bagian_c.dart
    ├── bagian_d.dart
    ├── latihan_mandiri_1.dart
    ├── latihan_mandiri_2.dart
    ├── latihan_mandiri_3.dart
    ├── latihan_mandiri_4.dart
    └── tugas_praktikum_5.dart
```

Struktur tersebut merupakan cara pengorganisasian pekerjaan saya. Modul sendiri memperbolehkan kode ditempatkan dalam `main.dart` atau berkas terpisah, serta Bagian B dilanjutkan pada proyek yang sama atau proyek baru.

## 3. Bagian A — SharedPreferences

Pada Bagian A, saya membuat halaman **Pengaturan**. Halaman ini memiliki kolom nama, tombol **Simpan nama**, sakelar **Mode gelap**, serta tulisan yang menunjukkan berapa kali aplikasi dibuka.

Untuk menyimpan nama, aplikasi menggunakan `prefs.setString('nama', ...)`, kemudian membaca kembali melalui `prefs.getString('nama')`. Mode gelap disimpan dengan `setBool()` dan dibaca menggunakan `getBool()`. Jumlah aplikasi dibuka dibaca dengan `getInt()`, ditambah satu ketika halaman mulai dijalankan, lalu disimpan kembali menggunakan `setInt()`.

Pemanggilan `_muat()` dilakukan melalui `initState()`, sedangkan `TextEditingController` dibersihkan pada `dispose()`. Saya memahami bahwa nilai bawaan seperti `?? ''` atau `?? false` dibutuhkan apabila pengaturan belum pernah disimpan.

**Pengujian:** nama diisi lalu disimpan, mode gelap diaktifkan, aplikasi dihentikan sepenuhnya, kemudian dijalankan kembali. Hasil yang diharapkan ialah nama dan mode gelap tidak berubah, sementara hitungan aplikasi dibuka bertambah. Bagian A telah berhasil dijalankan pada proses praktikum.

## 4. Bagian B — Menyiapkan SQLite

Pada Bagian B, saya mempelajari cara menyiapkan database untuk menyimpan catatan. Kode terdiri atas kelas `Catatan` sebagai model data dan `DbHelper` sebagai kelas pembantu database.

Model `Catatan` memiliki tiga atribut, yaitu `id`, `judul`, dan `isi`. Nilai `id` dibuat bertipe `int?` karena catatan baru belum memiliki ID. Saat disimpan, SQLite mengisinya secara otomatis melalui `AUTOINCREMENT`. Fungsi `toMap()` mengubah objek menjadi bentuk Map, sedangkan `fromMap()` mengubah data hasil query menjadi objek `Catatan`.

Database bernama `catatan.db` dibuka menggunakan `openDatabase()`. Pada versi 1, `onCreate` membuat tabel `catatan` dengan kolom `id`, `judul`, dan `isi`. Kelas `DbHelper` menyediakan fungsi `tambah()`, `semua()`, `ubah()`, dan `hapus()` sebagai implementasi CRUD.

**Pengujian:** aplikasi Bagian B berhasil dikompilasi dan dijalankan. Karena tahap ini baru menyiapkan model dan fungsi database, tampilan daftar catatan belum menjadi bagian dari pengujian. Akses database secara nyata baru digunakan oleh halaman daftar pada tahap berikutnya.

## 5. Bagian C — Halaman Daftar Catatan

Pada Bagian C, saya melanjutkan penggunaan `DbHelper` untuk membaca dan menghapus catatan melalui halaman **Catatan Saya**. Data dibaca menggunakan `DbHelper.semua()` dan ditampung dalam `Future<List<Catatan>>`.

Widget `FutureBuilder` digunakan untuk menangani proses pembacaan secara asynchronous. Saat menunggu data, aplikasi menampilkan `CircularProgressIndicator`. Jika terjadi masalah, aplikasi menampilkan pesan galat. Apabila tidak terdapat data, muncul tulisan **Belum ada catatan**. Ketika data tersedia, catatan ditampilkan menggunakan `ListView.builder` dan `ListTile`.

Pada setiap catatan terdapat ikon sampah untuk memanggil `DbHelper.hapus()`. Tombol tambah menggunakan `FloatingActionButton`, sedangkan `Navigator.push()` digunakan untuk membuka halaman formulir. Setelah kembali dari formulir, fungsi `_muat()` dipanggil supaya daftar diperbarui.

Dalam file tahap C yang dikerjakan, kode formulir dari Bagian D turut disertakan supaya tombol tambah dan buka catatan bisa langsung dijalankan. Ini adalah kebutuhan agar file tahap C dapat berdiri sendiri; materi formulir tetap dibahas pada Bagian D.

## 6. Bagian D — Form Tambah dan Ubah Catatan

Pada Bagian D, saya membuat halaman `FormCatatanPage` yang dapat digunakan untuk menambah atau mengubah catatan. Halaman yang sama digunakan untuk dua operasi dengan memeriksa apakah `widget.catatan` bernilai `null`.

Form memiliki kolom **Judul** dan **Isi catatan**. Keduanya memakai `TextFormField`, `TextEditingController`, dan validator. Jika salah satu kosong, aplikasi menampilkan pesan bahwa kolom tersebut wajib diisi.

Ketika menambah catatan, aplikasi memanggil `DbHelper.tambah()`. Ketika mengubah catatan lama, aplikasi memanggil `DbHelper.ubah()`. Setelah proses penyimpanan berhasil, halaman ditutup dengan `Navigator.pop(context)` dan halaman daftar memuat ulang datanya.

**Pengujian:** membuat catatan baru, membuka dan mengubah catatan yang sudah ada, menghapusnya melalui daftar, lalu menghentikan dan menjalankan aplikasi kembali untuk memeriksa bahwa data yang masih tersimpan tetap tersedia. Validasi judul dan isi kosong juga diuji.

## 7. Latihan Mandiri Nomor 1 — Konfirmasi Hapus

Latihan pertama meminta adanya `AlertDialog` sebelum catatan dihapus. Saya menambahkan dialog dengan pertanyaan **“Hapus catatan ini?”** dan dua pilihan, yaitu **Batal** dan **Hapus**.

Jika pengguna menekan **Batal**, dialog ditutup tanpa menghapus catatan. Jika memilih **Hapus**, aplikasi memanggil `DbHelper.hapus()` lalu memperbarui daftar melalui `_muat()`.

Dari latihan ini, saya memahami bahwa operasi hapus dapat diberi langkah konfirmasi terlebih dahulu agar pengguna dapat membatalkan tindakan. Latihan Mandiri Nomor 1 telah berhasil dijalankan.

## 8. Latihan Mandiri Nomor 2 — Pencarian Judul

Latihan kedua meminta kolom pencarian yang memfilter catatan berdasarkan judul. Pada kelas `DbHelper`, saya menambahkan query dengan ketentuan dari modul:

```dart
where: 'judul LIKE ?',
whereArgs: ['%$kata%'],
```

Kolom pencarian menggunakan `TextField`. Saat pengguna mengetik, aplikasi memuat catatan dengan judul yang sesuai. Tanda `%` memungkinkan pencarian kata yang terdapat pada bagian awal, tengah, atau akhir judul. Ketika kolom pencarian kosong, seluruh catatan ditampilkan kembali.

Pengujian dilakukan dengan menambahkan beberapa judul yang berbeda, mencari kata tertentu, mencoba kata yang tidak ditemukan, lalu mengosongkan pencarian. Fungsi CRUD dan konfirmasi hapus tetap dipertahankan. Latihan Mandiri Nomor 2 telah berhasil dijalankan.

## 9. Latihan Mandiri Nomor 3 — Tanggal Dibuat dan Migrasi Database

Latihan ketiga meminta penambahan kolom **`dibuat`** bertipe `TEXT`, perubahan versi database menjadi **2**, serta penambahan `onUpgrade` dengan perintah:

```sql
ALTER TABLE catatan ADD COLUMN dibuat TEXT
```

Pada model `Catatan`, atribut `dibuat` ditambahkan sebagai `String?` karena catatan lama dari database versi 1 mungkin belum memiliki tanggal. Ketika catatan baru disimpan, tanggal diperoleh dari `DateTime.now().toIso8601String()`. Ketika catatan diubah, tanggal pembuatannya dipertahankan. Tanggal juga ditampilkan pada daftar catatan sebagai bukti hasil implementasi.

Saya memahami perbedaan `onCreate` dan `onUpgrade`. `onCreate` dijalankan ketika database pertama kali dibuat, sedangkan `onUpgrade` digunakan ketika versi database yang sudah ada dinaikkan. Karena itu, database baru pada versi 2 langsung memiliki kolom `dibuat`, sementara database lama perlu diperbarui melalui `ALTER TABLE`.

Modul juga meminta pengamatan jika versi tidak dinaikkan. Pada database lama versi 1, jika kode mencoba menggunakan kolom `dibuat` tanpa migrasi, SQLite dapat menampilkan galat bahwa kolom tersebut belum ada. Kondisi ini perlu diamati pada database yang masih berada di versi 1, bukan dengan menurunkan versi database yang telanjur dimigrasikan.

Latihan Mandiri Nomor 3 telah berhasil dijalankan.

## 10. Latihan Mandiri Nomor 4 — Pengurutan dan SharedPreferences

Latihan keempat meminta pilihan urutan **Terbaru** dan **Terlama** disimpan menggunakan `shared_preferences`, kemudian diterapkan pada `orderBy` query SQLite.

Pengurutan menggunakan kolom `id` sebagai kelanjutan dari contoh pada Bagian B:

```dart
orderBy: terbaru ? 'id DESC' : 'id ASC',
```

Pilihan pengguna disimpan sebagai nilai boolean menggunakan `prefs.setBool('urutanTerbaru', nilai)` dan dibaca kembali dengan `prefs.getBool('urutanTerbaru') ?? true`. Pengguna memilih urutan melalui dropdown. Pengurutan diterapkan baik pada daftar seluruh catatan maupun pada hasil pencarian.

Pengujian dilakukan dengan membuat beberapa catatan berurutan, mengganti pilihan terbaru/terlama, menghentikan aplikasi sepenuhnya, dan menjalankannya kembali. Latihan Mandiri Nomor 4 telah berhasil dijalankan.

## 11. Bagian 6 — Tugas Aplikasi Pencatat Pengeluaran

Sebagai tugas akhir pertemuan, saya membuat **Aplikasi Pencatat Pengeluaran**. Tugas ini menerapkan konsep model data, database SQLite, operasi CRUD, validasi formulir, perhitungan total, dan SharedPreferences yang sudah dipelajari.

### 11.1 Model dan tabel pengeluaran

Aplikasi memakai model `Pengeluaran` dengan atribut `id`, `nama`, `jumlah`, `kategori`, dan `tanggal`. Database yang digunakan bernama `pengeluaran.db`, dengan struktur tabel sesuai ketentuan modul:

| Kolom | Tipe SQLite | Keterangan |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key dan `AUTOINCREMENT` |
| `nama` | `TEXT` | Nama pengeluaran, wajib diisi |
| `jumlah` | `INTEGER` | Nominal pengeluaran |
| `kategori` | `TEXT` | Kategori pengeluaran |
| `tanggal` | `TEXT` | Tanggal pencatatan |

### 11.2 Halaman daftar

Halaman utama menampilkan daftar pengeluaran yang sudah tersimpan dan **Total Pengeluaran**. Data dibaca dengan `FutureBuilder` dari SQLite. Jika database masih kosong, pengguna melihat informasi **Belum ada pengeluaran**. Ketika data tersedia, setiap baris memperlihatkan nama, jumlah, kategori, dan tanggal.

Total dihitung di Dart menggunakan `fold<int>()`, yaitu menjumlahkan nilai `jumlah` dari seluruh data yang berhasil dibaca. Modul memperbolehkan perhitungan melalui Dart maupun `SELECT SUM(jumlah)`; pengerjaan ini menggunakan Dart.

### 11.3 Form tambah dan ubah

Form memiliki kolom **Nama Pengeluaran**, **Jumlah Pengeluaran**, dan dropdown **Kategori**. Dalam implementasi yang dikerjakan, pilihan kategori contoh terdiri atas Makanan, Transportasi, Belanja, dan Lainnya; modul tidak menentukan daftar kategori tertentu.

Validasi yang digunakan sesuai instruksi tugas: nama tidak boleh kosong, jumlah harus berupa bilangan bulat lebih dari 0, dan kategori wajib dipilih. Proses tambah dan ubah memakai satu halaman. Saat menambah pengeluaran, tanggal dicatat secara otomatis; saat mengubahnya, tanggal yang tersimpan tetap dipertahankan.

### 11.4 Operasi hapus dan perhitungan ulang

Tiap pengeluaran dapat dihapus melalui ikon sampah yang memanggil `DbHelper.hapus()`. Setelah tambah, ubah, atau hapus, daftar dibaca kembali dari SQLite. Karena total dihitung dari isi daftar, nilai total ikut diperbarui sesuai data terbaru.

### 11.5 Pengaturan tersimpan

Sebagai satu pengaturan yang diminta dalam tugas, aplikasi menyimpan pilihan **Mode gelap** menggunakan `shared_preferences`. Nilai tersebut dibaca kembali ketika aplikasi dimulai sehingga mode pilihan sebelumnya tetap digunakan.

### 11.6 Penyimpanan setelah aplikasi ditutup

Data pengeluaran disimpan pada SQLite, bukan hanya di variabel halaman. Pengujian persistensi dilakukan dengan menambahkan pengeluaran, menghentikan aplikasi sepenuhnya, lalu menjalankannya kembali. Data yang tersimpan seharusnya tetap muncul selama penyimpanan aplikasi tidak dihapus.

Kode tugas dibuat dalam satu file **`tugas_praktikum_5.dart`** sebagaimana format pengerjaan yang dipilih. Bagian-bagian model, database, halaman daftar, dan formulir tetap diberi pemisah komentar agar mudah dibaca.

## 12. Urutan Pengujian Akhir Tugas

Pengujian aplikasi dilakukan melalui tahapan berikut:

1. Menjalankan `tugas_praktikum_5.dart` pada emulator Android dan memastikan halaman utama tampil.
2. Membuka form dengan tombol tambah dan menyimpan satu pengeluaran yang valid.
3. Memastikan pengeluaran muncul pada daftar dan total berubah sesuai nominalnya.
4. Menguji validasi dengan nama kosong, jumlah bukan angka, jumlah nol atau negatif, dan kategori yang belum dipilih.
5. Mengetuk data yang tersimpan, mengubah nominalnya, lalu memastikan perubahan muncul pada daftar dan total.
6. Menambahkan pengeluaran kedua, kemudian memeriksa hasil penjumlahan total.
7. Menghapus salah satu pengeluaran dan memastikan daftar serta total diperbarui.
8. Mengaktifkan mode gelap, menghentikan aplikasi, dan membukanya kembali untuk memeriksa pengaturan.
9. Menghentikan serta menjalankan ulang aplikasi untuk memeriksa bahwa data SQLite tetap tersimpan.

**Status:** Seluruh Bagian A–D dan Latihan Mandiri 1–4 telah dinyatakan berhasil dalam proses pengerjaan. Kode tugas Pencatat Pengeluaran telah disusun; pengujian akhir tugas perlu dicocokkan dengan hasil yang muncul pada emulator sebelum dinyatakan selesai sepenuhnya.

## 13. Dokumentasi Pengumpulan

Menurut modul, hasil pengumpulan tugas mencakup tangkapan layar **daftar pengeluaran**, **formulir**, **bukti bahwa data tetap ada setelah restart**, serta **berkas kode atau tautan repositori**. Untuk memudahkan pengarsipan, screenshot dapat disimpan dengan nama contoh berikut:

```text
01_daftar.png
02_form.png
03_restart.png
tugas_praktikum_5.dart
```

Nama file screenshot hanya usulan pengorganisasian, bukan syarat penamaan yang tertulis di modul. Screenshot perlu diambil langsung dari hasil pengujian emulator.

## 14. Kendala dan Hal yang Perlu Diperhatikan

Beberapa hal penting yang dibahas pada modul:

- Jika muncul `MissingPluginException` setelah memasang paket, hentikan aplikasi sepenuhnya dan jalankan kembali. Hot reload atau hot restart tidak memuat plugin baru.
- Jika data baru belum muncul pada daftar, periksa apakah `_muat()` dipanggil setelah proses tambah, ubah, atau hapus.
- Jika muncul galat `no such table` atau `no such column`, periksa kecocokan skema dengan versi database dan proses migrasinya.
- `sqflite` pada praktikum ini dijalankan di emulator Android sesuai alat yang dianjurkan dalam modul.
- Sesudah operasi `await`, pengecekan `if (!mounted) return;` digunakan sebelum memanfaatkan `context` atau memperbarui state ketika relevan.

## 15. Jawaban Refleksi Materi

**1. Mengapa SharedPreferences kurang cocok untuk ratusan catatan?** Karena SharedPreferences ditujukan untuk pengaturan kecil berbentuk key-value, bukan kumpulan data terstruktur. Untuk banyak catatan, SQLite lebih sesuai karena menyediakan tabel dan operasi CRUD.

**2. Mengapa memakai placeholder `?` dan `whereArgs`?** Karena nilai dipisahkan dari teks perintah SQL sehingga lebih aman daripada membentuk query dengan menyambungkan teks dari masukan pengguna.

**3. Mengapa daftar perlu dimuat ulang setelah kembali dari halaman form?** Karena database dapat berubah setelah pengguna menambah atau mengubah data. Pada kode praktikum, setelah `Navigator.push()` selesai, `_muat()` memanggil kembali `DbHelper.semua()` agar daftar menampilkan data terbaru.

**4. Apa perbedaan `onCreate` dan `onUpgrade`?** `onCreate` membuat tabel saat database pertama kali dibuat. `onUpgrade` menjalankan perubahan skema ketika nomor versi database yang sudah ada meningkat, seperti penambahan kolom `dibuat` pada latihan nomor 3.

## 16. Kesimpulan

Dari Praktikum Flutter Pertemuan 5, saya memahami bahwa penyimpanan lokal dibutuhkan untuk mempertahankan data meskipun aplikasi tidak sedang berjalan. **SharedPreferences** cocok untuk menyimpan pengaturan sederhana, sedangkan **SQLite** lebih sesuai untuk data terstruktur yang memerlukan operasi CRUD.

Pengerjaan dimulai dari penyimpanan nama dan mode gelap, berlanjut ke pembuatan model dan database catatan, tampilan daftar, form tambah dan ubah, lalu latihan konfirmasi hapus, pencarian, migrasi kolom tanggal, serta pengurutan yang tersimpan. Seluruh konsep tersebut kemudian diterapkan pada tugas **Aplikasi Pencatat Pengeluaran**, dengan validasi input, total pengeluaran, dan penyimpanan data lokal.

Melalui urutan tersebut, saya memahami keterkaitan antara tampilan Flutter, pengelolaan state, proses asynchronous, database SQLite, dan penyimpanan preferensi. Hasil akhir bukan hanya tampilan aplikasi, tetapi juga proses bagaimana data dibuat, dibaca, diubah, dihapus, dan dipertahankan setelah aplikasi dibuka kembali.

---

**Acuan:** Modul Praktikum Flutter Fundamental — Pertemuan 5: Penyimpanan Lokal (SharedPreferences dan SQLite), halaman 1–8. Tidak menggunakan materi tambahan di luar cakupan modul sebagai dasar pembahasan.

> **Nama:** Muhammad Yusuf Bagus Syafaat  
> **NIM:** 20240801041