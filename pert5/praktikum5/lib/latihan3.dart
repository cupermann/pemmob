
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String? dibuat;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
    this.dibuat,
  });

  Map<String, Object?> toMap() => {
    'judul': judul,
    'isi': isi,
    'dibuat': dibuat,
  };

  factory Catatan.fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
      dibuat: map['dibuat'] as String?,
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

      // Versi database dinaikkan menjadi 2
      version: 2,

      // Membuat tabel untuk database baru
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE catatan('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'judul TEXT NOT NULL, '
              'isi TEXT NOT NULL, '
              'dibuat TEXT)',
        );
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE catatan ADD COLUMN dibuat TEXT',
          );
        }
      },
    );

    return _db!;
  }

  // MENAMBAH CATATAN
  static Future<int> tambah(Catatan c) async {
    final db = await database;
    return db.insert('catatan', c.toMap());
  }

  // MENGAMBIL SEMUA CATATAN
  static Future<List<Catatan>> semua() async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      orderBy: 'id DESC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  // MENCARI CATATAN BERDASARKAN JUDUL
  static Future<List<Catatan>> cari(String kata) async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      where: 'judul LIKE ?',
      whereArgs: ['%$kata%'],
      orderBy: 'id DESC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  // MENGUBAH CATATAN
  static Future<int> ubah(Catatan c) async {
    final db = await database;

    return db.update(
      'catatan',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  // MENGHAPUS CATATAN
  static Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// APLIKASI UTAMA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 5',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const CatatanPage(),
    );
  }
}

// HALAMAN DAFTAR CATATAN
class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  late Future<List<Catatan>> _future;

  final TextEditingController _pencarianController =
  TextEditingController();

  String _kataPencarian = '';

  @override
  void initState() {
    super.initState();
    _muat();
  }

  // MEMUAT CATATAN SESUAI PENCARIAN
  void _muat() {
    final kata = _kataPencarian.trim();

    setState(() {
      _future = kata.isEmpty
          ? DbHelper.semua()
          : DbHelper.cari(kata);
    });
  }

  // MEMBUKA FORM TAMBAH ATAU EDIT
  Future<void> _buka([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormCatatanPage(
          catatan: catatan,
        ),
      ),
    );

    if (!mounted) return;
    _muat();
  }

  // MENGHAPUS CATATAN DENGAN KONFIRMASI
  Future<void> _hapus(int id) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Hapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) return;

    await DbHelper.hapus(id);

    if (!mounted) return;

    _muat();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil dihapus'),
      ),
    );
  }

  // FORMAT TANGGAL UNTUK DITAMPILKAN
  String _formatTanggal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak tersedia (catatan lama)';
    }

    final tanggal = DateTime.tryParse(value);

    if (tanggal == null) {
      return value;
    }

    final lokal = tanggal.toLocal();

    final hari = lokal.day.toString().padLeft(2, '0');
    final bulan = lokal.month.toString().padLeft(2, '0');
    final tahun = lokal.year;
    final jam = lokal.hour.toString().padLeft(2, '0');
    final menit = lokal.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/$tahun $jam:$menit';
  }

  @override
  void dispose() {
    _pencarianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
      ),
      body: Column(
        children: [
          // KOLOM PENCARIAN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _pencarianController,
              decoration: InputDecoration(
                hintText: 'Cari judul catatan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _kataPencarian.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Hapus pencarian',
                  onPressed: () {
                    _pencarianController.clear();
                    _kataPencarian = '';
                    _muat();
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (kata) {
                _kataPencarian = kata;
                _muat();
              },
            ),
          ),

          // DAFTAR CATATAN
          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Galat: ${snapshot.error}'),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      _kataPencarian.trim().isEmpty
                          ? 'Belum ada catatan'
                          : 'Catatan tidak ditemukan',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final c = data[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.note_alt_outlined,
                          ),
                        ),
                        title: Text(
                          c.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.isi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Dibuat: ${_formatTanggal(c.dibuat)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () => _buka(c),
                        trailing: IconButton(
                          tooltip: 'Hapus catatan',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _hapus(c.id!),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buka(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// FORM TAMBAH DAN EDIT CATATAN
class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const FormCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanPage> createState() =>
      _FormCatatanPageState();
}

class _FormCatatanPageState
    extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judul;
  late final TextEditingController _isi;

  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();

    _judul = TextEditingController(
      text: widget.catatan?.judul ?? '',
    );

    _isi = TextEditingController(
      text: widget.catatan?.isi ?? '',
    );
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  // MENYIMPAN CATATAN
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_sedangMenyimpan) return;

    setState(() {
      _sedangMenyimpan = true;
    });

    try {
      final c = Catatan(
        id: widget.catatan?.id,
        judul: _judul.text.trim(),
        isi: _isi.text.trim(),
        dibuat: widget.catatan == null
            ? DateTime.now().toIso8601String()
            : widget.catatan!.dibuat,
      );

      if (widget.catatan == null) {
        await DbHelper.tambah(c);
      } else {
        await DbHelper.ubah(c);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan catatan: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.catatan == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          baru ? 'Catatan Baru' : 'Ubah Catatan',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Masukkan judul catatan',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isi,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                hintText: 'Masukkan isi catatan',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:
              _sedangMenyimpan ? null : _simpan,
              icon: _sedangMenyimpan
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Icon(Icons.save),
              label: Text(
                _sedangMenyimpan
                    ? 'Menyimpan...'
                    : 'Simpan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
