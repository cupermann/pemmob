import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak(
      this.nama,
      this.telepon,
      this.email,
      );
}

const daftarKontak = [
  Kontak(
    'Rizqi Parung',
    '081234567890',
    'Parunkkk@gmail.com',
  ),
  Kontak(
    'Munir',
    '08124294521',
    'Muniratlet@gmail.com',
  ),
  Kontak(
    'Daus',
    '08120945672',
    'Dausdepot@gmail.com',
  ),
  Kontak(
    'Hariyanto',
    '08129342876',
    'Hariyanto@gmail.com',
  ),
  Kontak(
    'Heri',
    '08129657884',
    'Herigigi@gmail.com',
  ),
  Kontak(
    'Wawan',
    '08127854295',
    'Wanoffice@gmail.com',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const KontakPage(),
    );
  }
}

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text(kontak.nama[0]),
            ),
            title: Text(kontak.nama),
            subtitle: Text(kontak.telepon),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailKontakPage(
                    kontak: kontak,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kontak.nama),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                kontak.nama[0],
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              kontak.nama,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(kontak.telepon),
            const SizedBox(height: 8),
            Text(kontak.email),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}