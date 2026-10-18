
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class Catatan {
  final int? id;
  final String judul;
  final String isi;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': judul,
    'isi': isi,
  };

  factory Catatan.fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
    );
  }
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final lokasi = p.join(
      await getDatabasesPath(),
      'catatan.db',
    );

    _db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE catatan('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'judul TEXT NOT NULL, '
              'isi TEXT NOT NULL)',
        );
      },
    );

    return _db!;
  }

  static Future<int> tambah(Catatan c) async {
    final db = await database;
    return db.insert('catatan', c.toMap());
  }

  static Future<List<Catatan>> semua() async {
    final db = await database;
    final rows = await db.query(
      'catatan',
      orderBy: 'id DESC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  static Future<int> ubah(Catatan c) async {
    final db = await database;
    return db.update(
      'catatan',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 5 - Bagian B',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const DatabasePage(),
    );
  }
}

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  String status = 'Database belum diperiksa';
  bool loading = false;

  Future<void> _periksaDatabase() async {
    setState(() {
      loading = true;
      status = 'Memeriksa database...';
    });

    try {
      final db = await DbHelper.database;
      final hasil = await db.rawQuery(
        "SELECT name FROM sqlite_master "
            "WHERE type = 'table' AND name = 'catatan'",
      );

      if (!mounted) return;

      setState(() {
        status = hasil.isNotEmpty
            ? 'Database dan tabel catatan berhasil dibuat.'
            : 'Tabel catatan belum ditemukan.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bagian B - SQLite'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.storage,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                status,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                loading ? null : _periksaDatabase,
                child: Text(
                  loading
                      ? 'Memeriksa...'
                      : 'Periksa Database',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
