# README Praktikum Flutter Pertemuan 4

## Mengambil Data dari REST API dengan HTTP, Async, dan FutureBuilder

## 1. Pendahuluan

Praktikum Flutter Pertemuan 4 membahas cara mengambil data dari internet menggunakan REST API. Materi utama yang dipelajari adalah `Future`, `async`, `await`, package `http`, pengolahan data JSON, pembuatan model dengan `fromJson`, penggunaan `FutureBuilder`, serta penanganan kondisi loading dan error.

API yang digunakan dalam praktikum adalah **JSONPlaceholder**, yaitu API publik yang digunakan sebagai sumber data latihan.

Project praktikum dibuat dengan nama:

```bash
flutter create praktikum_4
```

Setelah project dibuat, seluruh latihan utama dikerjakan di dalam file:

```text
lib/main.dart
```

Untuk tugas akhir praktikum juga digunakan satu file `main.dart` karena materi pemisahan file belum dipelajari. Walaupun tetap satu file, model, fungsi pengambil data, dan widget UI dibuat sebagai bagian yang terpisah secara struktur agar kode lebih mudah dipahami.

---

## 2. Tujuan Pembelajaran

Setelah menyelesaikan praktikum ini, saya memahami beberapa hal berikut:

1. Cara kerja pemrograman asinkron pada Dart menggunakan `Future`, `async`, dan `await`.
2. Cara mengambil data dari REST API menggunakan package `http`.
3. Cara mengubah JSON menjadi objek Dart.
4. Cara membuat model data menggunakan factory constructor `fromJson`.
5. Cara menggunakan `FutureBuilder` untuk menampilkan data yang proses pengambilannya membutuhkan waktu.
6. Cara menampilkan indikator loading ketika data masih diproses.
7. Cara menampilkan pesan error ketika proses pengambilan data gagal.
8. Cara menyediakan tombol **Coba lagi** ketika terjadi kesalahan.
9. Cara berpindah halaman menggunakan `Navigator.push`.
10. Cara mengambil data tambahan dari endpoint lain pada halaman detail.

---

# 3. Bagian A — Mengenal Future dan FutureBuilder

Pada bagian pertama, aplikasi belum menggunakan koneksi internet.

Tujuan dari bagian ini adalah memahami konsep dasar `Future` dan `FutureBuilder`.

Fungsi yang digunakan:

```dart
Future<String> ambilSalam() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Halo dari masa depan!';
}
```

Fungsi tersebut mensimulasikan proses yang membutuhkan waktu selama dua detik.

Kemudian hasilnya ditampilkan menggunakan:

```dart
FutureBuilder<String>
```

Alur yang terjadi adalah:

```text
Aplikasi dijalankan
        ↓
Future dimulai
        ↓
Menunggu 2 detik
        ↓
CircularProgressIndicator tampil
        ↓
Future selesai
        ↓
"Halo dari masa depan!" ditampilkan
```

Pada bagian ini saya memahami bahwa `Future` merupakan hasil yang belum langsung tersedia dan akan tersedia setelah suatu proses selesai.

Saya juga memahami bahwa Future sebaiknya dibuat di dalam `initState()` dan bukan di dalam `build()`, agar proses Future tidak dijalankan ulang setiap kali widget melakukan rebuild.

---

# 4. Bagian B — Menyiapkan Package HTTP

Setelah memahami Future tanpa internet, langkah berikutnya adalah menambahkan package `http`.

Perintah yang dijalankan:

```bash
flutter pub add http
```

Package `http` digunakan agar aplikasi Flutter dapat melakukan request ke REST API.

Pada Android, izin internet juga perlu tersedia pada:

```text
android/app/src/main/AndroidManifest.xml
```

dengan:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Karena praktikum dikerjakan menggunakan macOS, bila aplikasi dijalankan sebagai aplikasi macOS desktop, izin jaringan keluar juga perlu diperhatikan melalui konfigurasi entitlement.

---

# 5. Bagian C — Membuat Model dan Mengambil Data API

Pada bagian ini aplikasi mulai mengambil data pengguna dari endpoint:

```text
https://jsonplaceholder.typicode.com/users
```

Dua import baru digunakan:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
```

`http` digunakan untuk melakukan request ke API.

Sedangkan:

```dart
jsonDecode()
```

digunakan untuk mengubah response JSON menjadi data Dart.

## Model Pengguna

Data dari API tidak digunakan langsung sebagai `Map`, tetapi diubah menjadi objek `Pengguna`.

Contoh struktur model:

```dart
class Pengguna {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
}
```

Data JSON kemudian diubah menjadi objek menggunakan:

```dart
factory Pengguna.fromJson(Map<String, dynamic> json)
```

Dari bagian ini saya memahami bahwa model membuat data lebih terstruktur dan lebih mudah digunakan di dalam aplikasi.

---

# 6. Fungsi ambilPengguna()

Untuk mengambil daftar pengguna digunakan fungsi:

```dart
Future<List<Pengguna>> ambilPengguna()
```

Urutan prosesnya adalah:

```text
Membuat URL API
        ↓
http.get()
        ↓
Menunggu response
        ↓
Memeriksa statusCode
        ↓
jsonDecode(response.body)
        ↓
Mengubah JSON ke objek Pengguna
        ↓
Menghasilkan List<Pengguna>
```

Jika status response bukan `200`, program menjalankan:

```dart
throw Exception(...)
```

Error tersebut nantinya dapat ditangkap oleh `FutureBuilder`.

---

# 7. Bagian D — Menampilkan Daftar Pengguna

Pada Bagian D, data yang sebelumnya hanya diambil dari API mulai ditampilkan ke layar.

Halaman utama diubah menjadi:

```dart
PenggunaPage
```

Kemudian data ditampilkan menggunakan:

```dart
FutureBuilder<List<Pengguna>>
```

`FutureBuilder` menangani tiga keadaan utama.

## Loading

Ketika data belum selesai diambil:

```dart
if (snapshot.connectionState == ConnectionState.waiting)
```

aplikasi menampilkan:

```dart
CircularProgressIndicator()
```

## Error

Jika terjadi kesalahan:

```dart
if (snapshot.hasError)
```

aplikasi menampilkan pesan error dan tombol:

```text
Coba lagi
```

## Data Berhasil

Jika data berhasil diperoleh, data ditampilkan menggunakan:

```dart
ListView.builder
```

Setiap pengguna menampilkan:

- huruf pertama nama pada `CircleAvatar`
- nama pengguna
- email
- ikon panah ke halaman detail

Pada bagian ini juga terdapat tombol refresh di AppBar untuk menjalankan kembali `ambilPengguna()`.

---

# 8. Bagian E — Halaman Detail Pengguna

Ketika salah satu pengguna ditekan, aplikasi membuka halaman baru menggunakan:

```dart
Navigator.push()
```

Halaman detail menerima objek `Pengguna` yang dipilih dari halaman sebelumnya.

Informasi yang ditampilkan adalah:

- email
- nomor telepon
- website

Dari bagian ini saya memahami bahwa objek yang sudah diperoleh dari API dapat dikirim ke halaman lain melalui constructor.

---

# 9. Bagian F — Percobaan Penanganan Error

Pada bagian ini dilakukan dua percobaan untuk memahami error handling.

## Percobaan 1 — URL Salah

URL:

```text
/users
```

diubah sementara menjadi:

```text
/userz
```

Karena endpoint tersebut tidak tersedia, API memberikan status error.

Aplikasi kemudian menampilkan pesan kesalahan melalui:

```dart
snapshot.hasError
```

Setelah URL dikembalikan ke alamat yang benar, tombol **Coba lagi** digunakan untuk mengambil data kembali.

## Percobaan 2 — Internet Dimatikan

Koneksi internet perangkat atau emulator dimatikan.

Kemudian tombol refresh ditekan.

Karena aplikasi tidak dapat mengakses API, aplikasi menampilkan error jaringan.

Setelah internet diaktifkan kembali, tombol **Coba lagi** digunakan untuk melakukan request ulang.

Dari percobaan ini saya memahami bahwa aplikasi yang menggunakan internet harus tetap dapat memberikan informasi kepada pengguna ketika request gagal.

---

# 10. Latihan Mandiri Nomor 1

Latihan pertama meminta penambahan dua informasi pada model pengguna:

```text
username
kota
```

Untuk username digunakan:

```dart
json['username']
```

Sedangkan kota berada di dalam objek `address`, sehingga digunakan:

```dart
json['address']['city']
```

Kedua data tersebut kemudian ditampilkan pada halaman detail pengguna.

Dari latihan ini saya memahami cara mengambil data JSON yang memiliki struktur bersarang.

---

# 11. Latihan Mandiri Nomor 2

Latihan kedua meminta daftar pengguna dibungkus dengan:

```dart
RefreshIndicator
```

Tujuannya agar pengguna dapat menarik daftar ke bawah untuk memuat ulang data.

Alurnya:

```text
Daftar pengguna tampil
        ↓
Tarik layar ke bawah
        ↓
RefreshIndicator aktif
        ↓
ambilPengguna() dijalankan kembali
        ↓
Daftar diperbarui
```

Latihan ini membuat saya memahami cara melakukan refresh data dengan gesture pull-to-refresh.

---

# 12. Latihan Mandiri Nomor 3

Latihan ketiga meminta aplikasi menangani kondisi ketika daftar pengguna kosong.

Pengecekan dilakukan menggunakan:

```dart
if (data.isEmpty)
```

Jika kondisi tersebut benar, aplikasi menampilkan:

```text
Tidak ada data
```

Kondisi ini berbeda dengan error.

Jika API gagal diakses, aplikasi masuk ke kondisi error.

Sedangkan `"Tidak ada data"` digunakan ketika proses berhasil tetapi hasil daftar yang diterima kosong.

Alurnya:

```text
Request API berhasil
        ↓
Data diterima
        ↓
Apakah List kosong?
        ↓
Ya → "Tidak ada data"
Tidak → tampilkan daftar pengguna
```

---

# 13. Latihan Mandiri Nomor 4

Latihan keempat meminta AppBar menampilkan jumlah pengguna setelah data berhasil dimuat.

Jumlah pengguna diperoleh menggunakan:

```dart
snapshot.data!.length
```

Contoh hasil pada AppBar:

```text
Daftar Pengguna (10)
```

Dari latihan ini saya memahami bahwa data dari Future tidak hanya dapat digunakan pada isi halaman, tetapi juga dapat digunakan untuk menampilkan informasi tambahan pada bagian lain dari UI.

---

# 14. Bagian 6 — Tugas Daftar Postingan

Setelah menyelesaikan latihan pengguna, tugas utama adalah membuat aplikasi **Daftar Postingan**.

API yang digunakan adalah:

```text
/posts
```

dan:

```text
/posts/{id}/comments
```

Aplikasi dibuat tetap dalam satu file:

```text
lib/main.dart
```

tetapi struktur kode tetap dipisahkan menjadi:

```text
Model
↓
Fungsi pengambil data
↓
UI
```

---

# 15. Model Post

Model `Post` digunakan untuk menyimpan data postingan.

Data yang digunakan adalah:

```text
userId
id
title
body
```

Data JSON diubah menggunakan:

```dart
Post.fromJson()
```

---

# 16. Model Komentar

Model `Komentar` digunakan untuk menyimpan data komentar.

Data yang digunakan adalah:

```text
postId
id
name
email
body
```

Data JSON diubah menjadi objek menggunakan:

```dart
Komentar.fromJson()
```

Dengan demikian tugas sudah menggunakan dua model sesuai ketentuan modul.

---

# 17. Mengambil Daftar Postingan

Fungsi:

```dart
ambilPost()
```

digunakan untuk mengambil data dari:

```text
https://jsonplaceholder.typicode.com/posts
```

Alurnya sama seperti `ambilPengguna()`:

```text
http.get()
↓
statusCode
↓
jsonDecode()
↓
Post.fromJson()
↓
List<Post>
```

---

# 18. Halaman Daftar Postingan

Halaman utama tugas menggunakan:

```dart
FutureBuilder<List<Post>>
```

Ketika data masih diproses, aplikasi menampilkan loading.

Jika gagal, aplikasi menampilkan pesan error dan tombol:

```text
Coba lagi
```

Jika berhasil, postingan ditampilkan menggunakan:

```dart
ListView.builder
```

Setiap item menampilkan:

- judul postingan
- potongan isi postingan
- ikon untuk membuka detail

Saat postingan ditekan, aplikasi membuka halaman detail.

---

# 19. Halaman Detail Postingan

Halaman detail menerima objek `Post`.

Informasi yang ditampilkan adalah:

```text
Judul postingan
Isi postingan lengkap
Komentar
```

Berbeda dari daftar postingan, pada halaman detail isi postingan ditampilkan secara lengkap.

---

# 20. Mengambil Komentar dengan Future Kedua

Komentar tidak ikut diambil ketika daftar postingan pertama kali dibuka.

Komentar baru diambil ketika halaman detail dibuka menggunakan:

```dart
ambilKomentar(postId)
```

Endpoint yang digunakan:

```text
/posts/{id}/comments
```

Contohnya:

```text
/posts/1/comments
```

Komentar menggunakan `FutureBuilder` kedua.

Dengan demikian terdapat dua proses Future yang berbeda:

```text
Future 1
/posts
↓
Daftar Postingan
```

dan:

```text
Future 2
/posts/{id}/comments
↓
Daftar Komentar
```

Future komentar juga menangani:

- loading
- error
- data komentar
- tombol Coba lagi

---

# 21. Alur Lengkap Aplikasi Tugas

Alur aplikasi dari awal sampai selesai adalah:

```text
Aplikasi dibuka
        ↓
PostPage
        ↓
ambilPost()
        ↓
Loading
        ↓
Daftar postingan tampil
        ↓
Pengguna memilih postingan
        ↓
DetailPostPage
        ↓
Judul dan isi lengkap tampil
        ↓
ambilKomentar(postId)
        ↓
Loading komentar
        ↓
Daftar komentar tampil
```

Jika request gagal:

```text
Request gagal
        ↓
snapshot.hasError
        ↓
Pesan kesalahan
        ↓
Tombol "Coba lagi"
        ↓
Request dijalankan kembali
```

---

# 22. Hasil Pemahaman Setelah Praktikum

Setelah menyelesaikan seluruh praktikum, saya memahami bahwa pengambilan data dari internet berbeda dengan data lokal karena hasilnya tidak langsung tersedia.

Karena itu aplikasi menggunakan `Future`.

`async` digunakan pada fungsi yang melakukan proses asinkron, sedangkan `await` digunakan untuk menunggu hasil dari proses tersebut tanpa membuat UI berhenti bekerja.

Saya juga memahami bahwa `FutureBuilder` sangat membantu untuk mengatur tampilan berdasarkan kondisi Future.

Kondisi yang paling sering digunakan adalah:

```text
waiting
error
data
```

Saya juga memahami alur dasar penggunaan REST API di Flutter:

```text
REST API
↓
http.get()
↓
Response
↓
Status Code
↓
JSON
↓
jsonDecode()
↓
fromJson()
↓
Model
↓
FutureBuilder
↓
UI
```

---

# 23. Kesimpulan

Praktikum Pertemuan 4 memberikan pemahaman dasar mengenai bagaimana Flutter berkomunikasi dengan REST API.

Praktikum dimulai dari konsep sederhana `Future` tanpa internet, kemudian berkembang menjadi pengambilan data nyata menggunakan package `http`.

Data JSON tidak langsung digunakan pada UI, tetapi terlebih dahulu diubah menjadi model agar lebih terstruktur.

Melalui `FutureBuilder`, aplikasi dapat menangani proses loading, menampilkan data ketika request berhasil, serta menampilkan pesan error ketika request gagal.

Latihan mandiri membantu memperkuat pemahaman melalui penambahan data bersarang, pull-to-refresh, pengecekan daftar kosong, dan jumlah data.

Pada tugas akhir, seluruh konsep yang sudah dipelajari digunakan kembali untuk membuat aplikasi Daftar Postingan yang memiliki halaman daftar, halaman detail, serta komentar yang diambil dari endpoint berbeda.

Dengan menyelesaikan praktikum ini, saya memahami alur dasar aplikasi Flutter yang menggunakan REST API mulai dari request, response, parsing JSON, model data, Future, FutureBuilder, navigasi, hingga penanganan error.

## Selesai

Praktikum Flutter Pertemuan 4 telah diselesaikan dari:

```text
Bagian A
↓
Bagian B
↓
Bagian C
↓
Bagian D
↓
Bagian E
↓
Bagian F
↓
Latihan Mandiri 1
↓
Latihan Mandiri 2
↓
Latihan Mandiri 3
↓
Latihan Mandiri 4
↓
Tugas Daftar Postingan
```

Seluruh proses tersebut menjadi dasar pemahaman penggunaan REST API pada Flutter dengan `http`, `async`, `await`, `Future`, `FutureBuilder`, JSON, model, navigasi, serta penanganan loading dan error.

> **Nama:** Muhammad Yusuf Bagus Syafaat  
> **NIM:** 20240801041