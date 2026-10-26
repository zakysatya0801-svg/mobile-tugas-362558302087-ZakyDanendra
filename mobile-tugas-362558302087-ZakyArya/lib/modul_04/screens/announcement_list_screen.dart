import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_api.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({
    super.key,
    this.api,
  });

  /// Dapat disuntikkan dari luar untuk widget test atau demo offline.
  final AnnouncementApi? api;

  @override
  State<AnnouncementListScreen> createState() =>
      _AnnouncementListScreenState();
}

class _AnnouncementListScreenState
    extends State<AnnouncementListScreen> {
  static const List<String> _kategori = <String>[
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  late final AnnouncementApi _api =
      widget.api ?? AnnouncementApi();

  late Future<List<Announcement>> _futurePengumuman;

  String _kategoriTerpilih = 'Semua';

  @override
  void initState() {
    super.initState();

    _futurePengumuman = _api.ambilPengumuman();
  }

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  Future<void> _muatUlang() async {
    final Future<List<Announcement>> futureBaru =
        _api.ambilPengumuman();

    setState(() {
      _futurePengumuman = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder.
    }
  }

  void _pilihKategori(String kategori) {
    if (kategori == _kategoriTerpilih) {
      return;
    }

    setState(() {
      _kategoriTerpilih = kategori;
    });
  }

  void _bukaDetail(Announcement announcement) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnnouncementDetailScreen(
          announcement: announcement,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pengumuman TRPL'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildBarisFilter(),

          const Divider(height: 1),

          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Announcement>> snapshot,
              ) {
                // ======================================================
                // KEADAAN 1 — LOADING
                // ======================================================
                if (snapshot.connectionState !=
                    ConnectionState.done) {
                  return _buildMemuat();
                }

                // ======================================================
                // KEADAAN 2 — ERROR
                // ======================================================
                if (snapshot.hasError) {
                  return _buildGagal(snapshot.error!);
                }

                // ======================================================
                // DATA DARI SERVER
                // ======================================================
                final List<Announcement> semua =
                    snapshot.data ??
                        const <Announcement>[];

                // Filter berdasarkan kategori
                final List<Announcement> tampil =
                    _kategoriTerpilih == 'Semua'
                        ? semua
                        : semua
                            .where(
                              (Announcement item) =>
                                  item.category.toLowerCase() ==
                                  _kategoriTerpilih.toLowerCase(),
                            )
                            .toList(growable: false);

                // ======================================================
                // KEADAAN 3 — KOSONG
                // ======================================================
                if (tampil.isEmpty) {
                  return _buildKosong();
                }

                // ======================================================
                // KEADAAN 4 — BERHASIL
                // ======================================================
                return _buildDaftar(tampil);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FILTER KATEGORI
  // ================================================================

  Widget _buildBarisFilter() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _kategori.length,
        separatorBuilder: (
          BuildContext context,
          int index,
        ) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final String kategori = _kategori[index];

          return ChoiceChip(
            label: Text(kategori),
            selected: kategori == _kategoriTerpilih,
            onSelected: (_) {
              _pilihKategori(kategori);
            },
          );
        },
      ),
    );
  }

  // ================================================================
  // KEADAAN 1 — LOADING
  // ================================================================

  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Sedang memuat pengumuman...',
          ),
        ],
      ),
    );
  }

  // ================================================================
  // KEADAAN 2 — ERROR
  // ================================================================

  Widget _buildGagal(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.cloud_off,
              size: 64,
            ),

            const SizedBox(height: 16),

            const Text(
              'Gagal Memuat Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // KEADAAN 3 — KOSONG
  // ================================================================

  Widget _buildKosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.inbox_outlined,
              size: 64,
            ),

            const SizedBox(height: 16),

            const Text(
              'Tidak ada pengumuman',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tidak ada pengumuman untuk kategori '
              '"$_kategoriTerpilih".',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // KEADAAN 4 — BERHASIL
  // ================================================================

  Widget _buildDaftar(
    List<Announcement> data,
  ) {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Announcement announcement = data[index];

          return AnnouncementCard(
            announcement: announcement,
            onTap: () {
              _bukaDetail(announcement);
            },
          );
        },
      ),
    );
  }
}