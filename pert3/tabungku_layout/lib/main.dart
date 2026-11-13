
import 'package:flutter/material.dart';

// Model untuk menyimpan data transaksi.
class Transaksi {
  final String judul;
  final String tanggal;
  final String nominal;
  final bool masuk;

  const Transaksi({
    required this.judul,
    required this.tanggal,
    required this.nominal,
    required this.masuk,
  });
}

// Data transaksi statis (hard-code).
const List<Transaksi> daftarTransaksi = [
  Transaksi(
    judul: 'Tarik Dana',
    tanggal: '12 November 2026',
    nominal: '-Rp 150.000',
    masuk: false,
  ),
  Transaksi(
    judul: 'Menabung',
    tanggal: '11 November 2026',
    nominal: '+Rp 900.000',
    masuk: true,
  ),
  Transaksi(
    judul: 'Menabung',
    tanggal: '10 November 2026',
    nominal: '+Rp 500.000',
    masuk: true,
  ),
];

// Titik awal aplikasi Flutter.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TabungKu Layout',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const RingkasanPage(),
    );
  }
}

// Halaman utama untuk menampilkan ringkasan tabungan.
class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar menampilkan judul halaman.
      appBar: AppBar(
        title: const Text('Ringkasan Tabungan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      // Padding memberi jarak dari tepi layar.
      // ListView.builder membuat halaman dapat di-scroll.
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: daftarTransaksi.length + 3,
          itemBuilder: (context, index) {

            // Bagian 1: Card menampilkan ringkasan tabungan.
            if (index == 0) {
              return Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  // Column menyusun informasi secara vertikal.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tabungan Pribadi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Row menyusun label dan saldo.
                      Row(
                        children: const [
                          Text('Saldo Saat Ini'),

                          // Expanded menggunakan sisa ruang.
                          Expanded(
                            child: Text(
                              'Rp 1.250.000',
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Row kedua menampilkan target tabungan.
                      Row(
                        children: const [
                          Text('Target Tabungan'),
                          Expanded(
                            child: Text(
                              'Rp 2.000.000',
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            // Bagian 2: Container mengatur jarak kategori.
            if (index == 1) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),

                // Row menyusun tiga kategori secara horizontal.
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [

                    // Kategori Menabung.
                    Expanded(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.add_circle_outline,
                            size: 36,
                            color: Colors.teal,
                          ),
                          SizedBox(height: 8),
                          Text('Menabung'),
                        ],
                      ),
                    ),

                    // Kategori Tarik.
                    Expanded(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.remove_circle_outline,
                            size: 36,
                            color: Colors.red,
                          ),
                          SizedBox(height: 8),
                          Text('Tarik'),
                        ],
                      ),
                    ),

                    // Kategori Riwayat.
                    Expanded(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.history,
                            size: 36,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 8),
                          Text('Riwayat'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Bagian 3: Judul daftar transaksi.
            if (index == 2) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Transaksi Terbaru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            // Bagian 4: Mengambil data transaksi dari list.
            final transaksi = daftarTransaksi[index - 3];

            // Card dan ListTile menampilkan setiap transaksi.
            return Card(
              child: ListTile(
                title: Text(
                  transaksi.judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Tanggal berada di bawah judul transaksi.
                subtitle: Text(transaksi.tanggal),

                // Nominal ditampilkan di sebelah kanan.
                trailing: Text(
                  transaksi.nominal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: transaksi.masuk
                        ? Colors.teal
                        : Colors.red,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
