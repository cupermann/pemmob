# Praktikum Flutter Fundamental — Pertemuan 2

**Nama:** Muhammad Yusuf Bagus Syafaat  
**NIM:** 20240801041

## Layout, ListView, dan Navigasi Antar Halaman

Repository ini berisi hasil praktikum **Flutter Fundamental Pertemuan 2** yang membahas pembuatan layout, menampilkan data dalam bentuk daftar menggunakan `ListView`, membuat model data sederhana menggunakan class Dart, serta melakukan navigasi antarhalaman menggunakan `Navigator`.

---

##  Materi Praktikum

Materi yang dipelajari pada praktikum ini meliputi:

* `Container`
* `Padding`
* `Row`
* `Column`
* `Expanded`
* `ListView.builder`
* `Card`
* `ListTile`
* Model data menggunakan `class` Dart
* Navigasi menggunakan `Navigator.push()`
* Kembali ke halaman sebelumnya menggunakan `Navigator.pop()`

---

##  Tujuan Praktikum

Setelah menyelesaikan praktikum ini, mahasiswa diharapkan mampu:

1. Menyusun layout menggunakan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`.
2. Menampilkan daftar data menggunakan `ListView.builder`, `Card`, dan `ListTile`.
3. Membuat model data sederhana menggunakan class Dart.
4. Membuat navigasi antarhalaman serta mengirim data menggunakan `Navigator.push()` dan `Navigator.pop()`.

---

##  Tools yang Digunakan

* Flutter SDK
* Dart
* Visual Studio Code / Android Studio
* Emulator Android atau perangkat fisik

---

##  Menjalankan Project

### 1. Clone Repository

```bash
git clone <URL_REPOSITORY>
```

### 2. Masuk ke Folder Project

```bash
cd praktikum_2
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Jalankan Aplikasi

```bash
flutter run
```

---

##  Struktur Program

Struktur utama program:

```text
lib/
└── main.dart
```

File `main.dart` berisi model data makanan, halaman daftar menu, dan halaman detail.

---

##  Implementasi Praktikum

### 1. Model Data

Data makanan dibuat menggunakan class `Makanan` yang memiliki dua atribut, yaitu `nama` dan `harga`.

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}
```

Data makanan kemudian disimpan dalam `daftarMenu`.

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

---

### 2. Menampilkan Daftar Menu

Daftar makanan ditampilkan menggunakan `ListView.builder`. Setiap data ditampilkan menggunakan `Card` dan `ListTile`.

```dart
ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(item.nama),
        subtitle: Text('Rp ${item.harga}'),
      ),
    );
  },
)
```

---

### 3. Navigasi ke Halaman Detail

Ketika salah satu menu dipilih, aplikasi berpindah ke halaman detail menggunakan `Navigator.push()`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPage(
      makanan: item,
    ),
  ),
);
```

Data makanan yang dipilih dikirim ke `DetailPage` melalui constructor.

---

### 4. Kembali ke Halaman Sebelumnya

Halaman detail menggunakan `Navigator.pop()` untuk kembali ke halaman daftar.

```dart
ElevatedButton(
  onPressed: () => Navigator.pop(context),
  child: const Text('Kembali'),
)
```

---

##  Latihan Mandiri

Pada latihan mandiri dilakukan beberapa pengembangan terhadap aplikasi, yaitu:

1. Menambahkan 3 menu baru ke dalam `daftarMenu`.
2. Menambahkan properti deskripsi pada class `Makanan`.
3. Menampilkan deskripsi pada halaman detail.
4. Mengganti `Card` dengan `Container` yang memiliki warna latar dan sudut membulat.
5. Menampilkan harga dengan format ribuan.

### Hasil Penambahan Data

Setelah latihan, daftar menu dikembangkan menjadi:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
  Makanan('Ketoprak', 15000),
  Makanan('Rendang', 14000),
  Makanan('Es Jeruk', 5000),
];
```

---

## 📝 Tugas

Tugas pada praktikum ini adalah membuat aplikasi **Daftar Kontak** dengan ketentuan:

* Minimal 6 kontak.
* Setiap kontak memiliki nama, nomor telepon, dan email.
* Data disimpan dalam list yang berisi objek dari sebuah class.
* Halaman utama menggunakan `ListView.builder` dan `ListTile`.
* Avatar menampilkan huruf pertama dari nama kontak.
* Kontak dapat dipilih untuk membuka halaman detail.
* Halaman detail menampilkan seluruh data kontak.
* Terdapat tombol untuk kembali ke halaman sebelumnya.

##  Kesimpulan

Praktikum ini memberikan pemahaman mengenai penggunaan widget Flutter untuk membuat layout dan menampilkan data dalam bentuk daftar. Selain itu, praktikum memperkenalkan penggunaan class Dart sebagai model data serta penggunaan `Navigator.push()` dan `Navigator.pop()` untuk melakukan navigasi dan mengirim data antarhalaman.

Melalui latihan mandiri, daftar menu dikembangkan dengan menambahkan beberapa data baru sehingga dapat memahami penggunaan `ListView.builder` untuk menampilkan data yang lebih banyak dan tetap dapat digulir.

---

## Referensi

* Modul Praktikum Flutter Fundamental — Pertemuan 2: Layout, ListView, dan Navigasi Antar Halaman.
* Dokumentasi Flutter — Layout.
* Dokumentasi Flutter — Lists.
* Dokumentasi Flutter — Navigation.
---