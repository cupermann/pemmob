import 'dart:async';

import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({
    super.key,
    required this.pengaturan,
  });

  final Pengaturan pengaturan;

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _DataHari {
  const _DataHari({
    required this.kegiatan,
    required this.ringkasan,
  });

  final List<Kegiatan> kegiatan;
  final Ringkasan ringkasan;
}

class _BerandaPageState extends State<BerandaPage> {
  final TextEditingController _pencarianController =
  TextEditingController();

  final FocusNode _fokusPencarian = FocusNode();

  Timer? _debounce;
  Tipe? _filterTipe;

  late Future<_DataHari> _future;

  _DataHari? _dataTerakhir;

  @override
  void initState() {
    super.initState();

    _future = _ambil();
    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    versiData.removeListener(_muat);
    _pencarianController.dispose();
    _fokusPencarian.dispose();

    super.dispose();
  }

  Future<_DataHari> _ambil() async {
    final tanggal = formatTanggalDatabase(DateTime.now());

    final pencarian = _pencarianController.text.trim();
    final filter = _filterTipe;

    final hasil = await Future.wait<Object>([
      DbHelper.cariPada(
        tanggal,
        pencarian: pencarian,
        tipe: filter,
      ),
      DbHelper.ringkasan(tanggal),
    ]);

    return _DataHari(
      kegiatan: hasil[0] as List<Kegiatan>,
      ringkasan: hasil[1] as Ringkasan,
    );
  }

  void _muat() {
    if (!mounted) return;

    setState(() {
      _future = _ambil();
    });
  }

  void _cariKegiatan(String nilai) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 350),
          () {
        if (mounted) {
          _muat();
        }
      },
    );
  }

  void _hapusPencarian() {
    _debounce?.cancel();
    _pencarianController.clear();
    _muat();
  }

  void _ubahFilter(Tipe? tipe) {
    _debounce?.cancel();

    setState(() {
      _filterTipe = tipe;
      _future = _ambil();
    });
  }

  Future<void> _bukaForm([Kegiatan? kegiatan]) async {
    await Navigator.of(context).pushNamed<bool>(
      '/kegiatan',
      arguments: kegiatan,
    );
  }

  Future<void> _centang(
      Kegiatan kegiatan,
      bool selesai,
      ) async {
    if (kegiatan.id == null) return;

    try {
      await DbHelper.ubahSelesai(
        kegiatan.id!,
        selesai,
      );
    } catch (error) {
      _tampilkanPesan('Gagal mengubah status: $error');
    }
  }

  Future<void> _hapus(Kegiatan kegiatan) async {
    if (kegiatan.id == null) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kegiatan?'),
          content: Text(
            'Kegiatan "${kegiatan.judul}" akan dihapus permanen.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    try {
      await DbHelper.hapus(kegiatan.id!);
      _tampilkanPesan('Kegiatan berhasil dihapus.');
    } catch (error) {
      _tampilkanPesan('Gagal menghapus kegiatan: $error');
    }
  }

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabungKu'),
        actions: [
          IconButton(
            tooltip: 'Muat Ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _muat,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Kegiatan'),
      ),
      body: ListView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Text(
            formatTanggalPanjang(DateTime.now()),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          FutureBuilder<_DataHari>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _dataTerakhir = snapshot.data;
              }

              final data = snapshot.data ?? _dataTerakhir;

              if (data == null) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Gagal memuat ringkasan.'),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RingkasanCard(
                ringkasan: data.ringkasan,
                target: widget.pengaturan.target,
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            'Daftar Kegiatan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Pencarian berada di luar FutureBuilder,
          // sehingga tidak kehilangan fokus saat data dimuat.
          TextField(
            controller: _pencarianController,
            focusNode: _fokusPencarian,
            onChanged: _cariKegiatan,
            decoration: InputDecoration(
              labelText: 'Cari kegiatan',
              hintText: 'Nama atau kategori',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Hapus pencarian',
                icon: const Icon(Icons.close),
                onPressed: _hapusPencarian,
              ),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<Tipe?>(
            initialValue: _filterTipe,
            decoration: const InputDecoration(
              labelText: 'Filter Jenis Keuangan',
              prefixIcon: Icon(Icons.filter_list),
            ),
            items: const [
              DropdownMenuItem<Tipe?>(
                value: null,
                child: Text('Semua Jenis'),
              ),
              DropdownMenuItem<Tipe?>(
                value: Tipe.tanpa,
                child: Text('Tanpa Uang'),
              ),
              DropdownMenuItem<Tipe?>(
                value: Tipe.pemasukan,
                child: Text('Pemasukan'),
              ),
              DropdownMenuItem<Tipe?>(
                value: Tipe.pengeluaran,
                child: Text('Pengeluaran'),
              ),
            ],
            onChanged: _ubahFilter,
          ),

          const SizedBox(height: 16),

          FutureBuilder<_DataHari>(
            future: _future,
            builder: (context, snapshot) {
              final data = snapshot.data ?? _dataTerakhir;

              if (data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Column(
                  children: [
                    const Text('Gagal memperbarui kegiatan.'),
                    TextButton(
                      onPressed: _muat,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (snapshot.connectionState ==
                      ConnectionState.waiting)
                    const LinearProgressIndicator(minHeight: 2),

                  const SizedBox(height: 8),

                  Text(
                    '${data.kegiatan.length} kegiatan ditampilkan',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 12),

                  if (data.kegiatan.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'Tidak ada kegiatan yang ditemukan.',
                        ),
                      ),
                    )
                  else
                    ...data.kegiatan.map((kegiatan) {
                      return KegiatanTile(
                        key: ValueKey(kegiatan.id),
                        kegiatan: kegiatan,
                        onCentang: (nilai) {
                          _centang(kegiatan, nilai);
                        },
                        onUbah: () {
                          _bukaForm(kegiatan);
                        },
                        onHapus: () {
                          _hapus(kegiatan);
                        },
                      );
                    }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}