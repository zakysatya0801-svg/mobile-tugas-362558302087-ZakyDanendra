import 'package:flutter/material.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';

class BerandaPengayaanScreen extends StatelessWidget {
  final SesiController controller;
  final SesiPengguna sesi;
  const BerandaPengayaanScreen({super.key, required this.controller, required this.sesi});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Fase B • Beranda')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Text('Selamat datang, ${sesi.nama}', style: Theme.of(context).textTheme.headlineSmall), Text(sesi.email), Text('Peran: ${SesiPengguna.labelPeran(sesi.peran)}'),
    const SizedBox(height: 12), Text('Masa berlaku sampai: ${sesi.kedaluwarsaPada}'),
    PapanDiagnostikPenyimpanan(repository: controller.repository),
    Wrap(spacing: 8, children: [FilledButton.icon(onPressed: controller.perbaruiSesi, icon: const Icon(Icons.refresh), label: const Text('Perbarui sesi')), OutlinedButton.icon(onPressed: controller.keluar, icon: const Icon(Icons.logout), label: const Text('Keluar'))]),
  ]));
}
