# Praktikum Flutter Fundamental: Pertemuan 1

> **Nama:** Muhammad Yusuf Bagus Syafaat 
> **NIM:** 20240801041

## Tentang Praktikum

Praktikum ini merupakan pengenalan dasar mengenai **Flutter dan Dart** untuk membuat aplikasi sederhana. Pada praktikum ini saya mempelajari bagaimana melakukan instalasi dan verifikasi Flutter, membuat project Flutter pertama, memahami struktur project, serta menggunakan berbagai widget dasar untuk membangun tampilan aplikasi.

Selain mempelajari tampilan, praktikum ini juga memperkenalkan konsep **StatefulWidget** dan `setState()` untuk membuat aplikasi yang dapat merespons perubahan data.

---

## Tujuan Praktikum

Setelah melakukan praktikum ini, saya memahami beberapa hal dasar dalam pengembangan aplikasi Flutter, yaitu:

* Mengenal Flutter sebagai framework untuk membuat aplikasi.
* Mengenal Dart sebagai bahasa pemrograman yang digunakan Flutter.
* Membuat dan menjalankan project Flutter.
* Memahami struktur dasar project Flutter.
* Memahami konsep widget dalam Flutter.
* Menggunakan `StatelessWidget` dan `StatefulWidget`.
* Menggunakan `setState()` untuk memperbarui tampilan.
* Menggunakan fitur **Hot Reload** saat proses pengembangan aplikasi.

---

## Tools yang Digunakan

* Flutter SDK
* Dart
* Android Studio
* Android Emulator
* Visual Studio Code / Android Studio
* Git & GitHub

---

## Pemahaman yang Saya Dapatkan

### 1. Flutter dan Dart

Saya memahami bahwa **Flutter** digunakan untuk membangun antarmuka aplikasi, sedangkan **Dart** merupakan bahasa pemrograman yang digunakan dalam pengembangan aplikasi Flutter.

Dalam Flutter, tampilan aplikasi dibangun menggunakan konsep **widget**. Elemen seperti teks, icon, layout, tombol, dan struktur aplikasi dapat dibuat menggunakan widget.

### 2. Widget

Saya memahami bahwa widget merupakan bagian utama dalam membangun tampilan aplikasi Flutter.

Beberapa widget yang digunakan pada praktikum ini antara lain:

* `MaterialApp`
* `Scaffold`
* `AppBar`
* `Center`
* `Column`
* `Text`
* `Icon`
* `SizedBox`
* `FloatingActionButton`

Widget tersebut dapat disusun menjadi sebuah struktur yang disebut **widget tree**.

Contohnya:

```text
MaterialApp
└── Scaffold
    ├── AppBar
    └── Center
        └── Column
            ├── Icon
            ├── SizedBox
            └── Text
```

### 3. StatelessWidget

Saya memahami bahwa `StatelessWidget` digunakan ketika tampilan widget tidak membutuhkan perubahan state.

Pada praktikum, `MyApp` menggunakan `StatelessWidget` sebagai dasar aplikasi.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 1',
      home: CounterPage(),
    );
  }
}
```

### 4. StatefulWidget

Saya memahami bahwa `StatefulWidget` digunakan ketika terdapat data atau keadaan yang dapat berubah selama aplikasi berjalan.

Pada aplikasi counter, nilai `_count` dapat berubah ketika tombol ditekan.

```dart
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}
```

### 5. Penggunaan `setState()`

Saya memahami bahwa perubahan nilai pada state perlu dilakukan menggunakan `setState()` agar Flutter mengetahui bahwa terdapat perubahan data dan memperbarui tampilan.

Contohnya:

```dart
setState(() {
  _count++;
});
```

Ketika tombol ditekan, nilai `_count` bertambah dan tampilan aplikasi ikut diperbarui.

### 6. Hot Reload

Saya memahami bahwa **Hot Reload** dapat digunakan untuk melihat perubahan kode secara langsung pada aplikasi tanpa harus menjalankan aplikasi dari awal.

Fitur ini membantu mempercepat proses pengembangan karena perubahan pada tampilan dapat langsung diamati.

---

## Hasil Praktikum

Pada praktikum ini saya berhasil membuat beberapa implementasi dasar Flutter, yaitu:

1. Menjalankan project Flutter pertama.
2. Membuat tampilan **Hello Flutter**.
3. Menggunakan `Column` untuk menyusun widget secara vertikal.
4. Membuat aplikasi counter menggunakan `StatefulWidget`.
5. Menambahkan tombol untuk menambah dan mengurangi angka.
6. Membuat tombol reset.
7. Mencegah nilai counter menjadi negatif.
8. Membuat aplikasi **Kartu Perkenalan**.

---

## Tugas Kartu Perkenalan

Sebagai tugas praktikum, saya membuat aplikasi **Kartu Perkenalan** dalam satu halaman.

Informasi yang ditampilkan:

* Icon
* Nama
* NIM
* Jurusan
* Hobi

Widget yang digunakan:

```text
Column
├── Icon
├── SizedBox
├── Text
├── Text
├── Text
└── Text
```

Contoh tampilan aplikasi:

```text
┌─────────────────────────────┐
│      Kartu Perkenalan       │
│                             │
│            👶               │
│                             │
│ Muhammad Yusuf Bagus        │
│ Syafaat                     │
│ NIM: 20240801041            │
│ Jurusan: Teknik Informatika │
│ Hobi: Bermain Game dan Tidur│
│                             │
└─────────────────────────────┘
```

---

##  Kesimpulan

Dari praktikum ini saya memahami bahwa Flutter menggunakan widget sebagai komponen utama untuk membangun tampilan aplikasi. Saya juga memahami perbedaan penggunaan `StatelessWidget` dan `StatefulWidget`, serta bagaimana `setState()` digunakan untuk memperbarui tampilan ketika terjadi perubahan data.

Selain itu, saya memahami penggunaan beberapa widget dasar seperti `Column`, `Text`, `Icon`, dan `SizedBox` untuk menyusun tampilan aplikasi. Melalui tugas Kartu Perkenalan, konsep-konsep tersebut dapat diterapkan secara langsung untuk membuat aplikasi Flutter sederhana dalam satu halaman.

Praktikum ini menjadi dasar untuk memahami cara kerja Flutter sebelum melanjutkan ke pembuatan aplikasi dengan tampilan dan fungsi yang lebih kompleks.

---

## Referensi

* [Flutter Documentation](https://docs.flutter.dev/)
* [Dart Language Tour](https://dart.dev/language)
* [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

---
