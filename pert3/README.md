# 📱 Praktikum Flutter Fundamental — Pertemuan 3

> **Nama:** Muhammad Yusuf Bagus Syafaat  
> **NIM:** 20240801041

## Form Input dan State Management

Praktikum ini membahas cara menerima input dari pengguna, melakukan validasi data, serta mengelola state pada aplikasi Flutter menggunakan `setState`, `ChangeNotifier`, dan `Provider`.

---

##  Tujuan Praktikum

Setelah menyelesaikan praktikum ini, mahasiswa diharapkan dapat:

* Menggunakan `TextField` dan `TextEditingController`.
* Membuat `Form` dengan validasi menggunakan `TextFormField`.
* Memahami perbedaan **ephemeral state** dan **app state**.
* Menggunakan `ChangeNotifier` untuk mengelola state.
* Menggunakan `Provider` untuk membagikan state antar-widget atau halaman.
* Memahami penggunaan `context.watch()` dan `context.read()`.

---

## Materi yang Dipelajari

### 1. TextField dan TextEditingController

`TextField` digunakan untuk menerima input teks dari pengguna, sedangkan `TextEditingController` digunakan untuk membaca dan mengelola nilai yang dimasukkan.

Controller perlu di-`dispose()` ketika widget sudah tidak digunakan.

### 2. Form dan Validasi

Flutter menyediakan `Form` dan `TextFormField` untuk membuat form yang memiliki validasi.

Validasi dapat dilakukan menggunakan:

```dart
validator: (value) {
  // validasi input
}
```

Kemudian seluruh validasi form dapat dijalankan menggunakan:

```dart
_formKey.currentState!.validate();
```

### 3. State Management

State merupakan data yang dapat berubah dan memengaruhi tampilan aplikasi.

Pada praktikum ini dipelajari dua jenis state:

* **Ephemeral State** — state yang hanya digunakan oleh satu widget.
* **App State** — state yang dapat digunakan oleh beberapa widget atau halaman.

### 4. ChangeNotifier dan Provider

`ChangeNotifier` digunakan sebagai tempat untuk mengelola state. Ketika terjadi perubahan data, `notifyListeners()` digunakan untuk memberitahu widget yang menggunakan state tersebut.

Provider digunakan untuk menyediakan state agar dapat diakses oleh widget lain.

```dart
context.watch<TugasModel>()
```

digunakan untuk membaca state sekaligus memantau perubahan.

Sedangkan:

```dart
context.read<TugasModel>()
```

digunakan untuk mengakses state tanpa berlangganan terhadap perubahan state.

---

#  Praktikum

## Praktikum A — Input Dasar

Pada tahap pertama dibuat input nama menggunakan `TextField` dan `TextEditingController`.

Pengguna dapat memasukkan nama kemudian menekan tombol **Sapa** untuk menampilkan pesan sapaan.

Konsep yang diterapkan:

* `StatefulWidget`
* `TextField`
* `TextEditingController`
* `setState()`
* `dispose()`

---

## Praktikum B — Form dan Validasi

Tahap berikutnya membuat form pendaftaran yang terdiri dari:

* Nama lengkap
* Email
* Jurusan
* Checkbox persetujuan
* Tombol Daftar

Validasi diterapkan pada setiap input. Tombol **Daftar** hanya dapat digunakan setelah pengguna menyetujui ketentuan.

Konsep yang digunakan:

```text
Form
 ├── Nama
 ├── Email
 ├── Dropdown Jurusan
 ├── Checkbox Persetujuan
 └── Tombol Daftar
```

---

## Praktikum C — State Management

Pada tahap ini dibuat aplikasi daftar tugas untuk memahami penggunaan `ChangeNotifier`.

Data tugas memiliki:

* Judul tugas
* Status selesai

`TugasModel` digunakan sebagai state utama untuk melakukan operasi:

```text
Tambah tugas
     ↓
Ubah status tugas
     ↓
Hapus tugas
```

Setiap perubahan data diikuti dengan:

```dart
notifyListeners();
```

agar tampilan aplikasi diperbarui.

---

## Praktikum D — Provider

Pada tahap ini `TugasModel` dibagikan menggunakan `ChangeNotifierProvider`.

```dart
ChangeNotifierProvider(
  create: (_) => TugasModel(),
  child: const MyApp(),
)
```

Halaman daftar menggunakan `context.watch()` untuk mendapatkan data dan merespons perubahan state.

Sementara itu, operasi seperti menambah, mengubah, dan menghapus data menggunakan `context.read()`.

---

# Tugas Praktikum — Aplikasi Daftar Belanja

Sebagai tugas penerapan materi, dibuat aplikasi **Daftar Belanja**.

## Fitur

### Form Tambah

Form harus memiliki:

* Nama barang — wajib diisi.
* Jumlah — wajib diisi dan harus berupa angka lebih dari 0.
* Kategori — menggunakan dropdown.
* Validasi pada setiap isian.

### Halaman Daftar

Halaman daftar harus dapat:

* Menampilkan seluruh barang.
* Menandai barang sebagai **sudah dibeli**.
* Menghapus barang.
* Menampilkan jumlah barang yang belum dibeli.

### State Management

State aplikasi disimpan pada satu `ChangeNotifier` dan dibagikan menggunakan `Provider`.

---

#  Konsep yang Diterapkan

Struktur pengelolaan data pada aplikasi:

```text
User Input
    ↓
Form & Validation
    ↓
ChangeNotifier
    ↓
Provider
    ↓
Halaman Daftar
    ↓
Tampilkan / Checklist / Hapus
```

Dengan pendekatan tersebut, data daftar belanja dikelola pada satu state sehingga dapat digunakan oleh halaman yang membutuhkan.

---

# Refleksi

Beberapa hal yang dipahami setelah praktikum:

### Mengapa `TextEditingController` perlu di-dispose?

Karena controller merupakan resource yang digunakan selama widget aktif dan perlu dilepaskan ketika widget tidak lagi digunakan.

### Kapan menggunakan `setState()` dan kapan menggunakan Provider?

`setState()` sesuai digunakan untuk state sederhana yang hanya dibutuhkan oleh satu widget. Provider dapat digunakan ketika state perlu digunakan oleh beberapa widget atau halaman.

### Apa yang terjadi jika `notifyListeners()` tidak dipanggil?

Perubahan data pada model tidak akan memberitahu widget yang menggunakan state tersebut sehingga tampilan tidak otomatis diperbarui.

### Mengapa menggunakan `context.read()` pada callback?

Karena callback hanya perlu mengakses model untuk menjalankan suatu aksi, seperti menambah, mengubah, atau menghapus data, tanpa perlu berlangganan terhadap perubahan state.

---

#  Kesimpulan

Praktikum Flutter Fundamental Pertemuan 3 memberikan pemahaman mengenai **input pengguna, validasi form, dan state management**. Materi tersebut kemudian diterapkan melalui aplikasi daftar tugas dan tugas utama berupa aplikasi Daftar Belanja.

Melalui praktikum ini, penggunaan `TextField`, `Form`, `ChangeNotifier`, dan `Provider` dapat dipahami secara langsung. Penggunaan `context.watch()` dan `context.read()` juga membantu membedakan cara membaca state dan menjalankan aksi terhadap state dalam aplikasi Flutter.

---

##  Teknologi

* Flutter
* Dart
* Provider
* ChangeNotifier

---

###  Flutter Fundamental

**Form Input • Validation • State Management • Provider**