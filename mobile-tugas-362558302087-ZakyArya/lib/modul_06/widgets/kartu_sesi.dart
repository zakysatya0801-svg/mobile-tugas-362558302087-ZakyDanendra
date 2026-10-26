import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback onKeluar;
  const KartuSesi({super.key, required this.sesi, required this.sekarang, required this.onKeluar});

  String _tanggal(String nilai) {
    final tanggal = DateTime.tryParse(nilai);
    if (tanggal == null) return 'Tanggal tidak valid';
    final d = tanggal.toLocal();
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${dua(d.day)}/${dua(d.month)}/${d.year} ${dua(d.hour)}:${dua(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final sisa = sesi.sisaWaktu(sekarang);
    final token = sesi.token.length > 12 ? '${sesi.token.substring(0, 8)}••••${sesi.token.substring(sesi.token.length - 4)}' : '••••••••';
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.verified_user_outlined), SizedBox(width: 8), Text('Sesi aktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          Text(sesi.nama, style: Theme.of(context).textTheme.titleLarge),
          Text(sesi.email),
          const SizedBox(height: 8),
          Chip(label: Text(SesiPengguna.labelPeran(sesi.peran))),
          const Divider(height: 24),
          _baris('Masuk pada', _tanggal(sesi.masukPada)),
          _baris('Kedaluwarsa', _tanggal(sesi.kedaluwarsaPada)),
          _baris('Sisa waktu', '${sisa.inHours} jam ${sisa.inMinutes.remainder(60)} menit'),
          _baris('Token demo', token),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onKeluar, icon: const Icon(Icons.logout), label: const Text('Keluar'))),
        ]),
      ),
    );
  }

  Widget _baris(String label, String nilai) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 105, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))), Expanded(child: Text(nilai))]),
      );
}
