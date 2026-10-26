import 'package:flutter/material.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/sesi_memori.dart';
import 'controllers/sesi_controller.dart';
import 'repositories/aman_sesi_repository.dart';
import 'repositories/memori_sesi_repository.dart';
import 'repositories/prefs_sesi_repository.dart';
import 'repositories/sesi_repository.dart';
import 'screens/beranda_pengayaan_screen.dart';
import 'screens/login_pengayaan_screen.dart';
import 'storage/penyimpanan_aman_platform.dart';
import 'widgets/gerbang_sesi.dart';

class Modul06PengayaanApp extends StatefulWidget {
  const Modul06PengayaanApp({super.key});
  @override State<Modul06PengayaanApp> createState() => _Modul06PengayaanAppState();
}
class _Modul06PengayaanAppState extends State<Modul06PengayaanApp> {
  String _pilihan = 'Memori';
  late SesiController _kendali;
  SesiRepository _buatRepository(String pilihan) => switch (pilihan) {
    'SharedPreferences' => PrefsSesiRepository(),
    'Secure storage' => AmanSesiRepository(const PenyimpananAmanPlatform()),
    _ => MemoriSesiRepository(SesiMemori()),
  };
  @override void initState() { super.initState(); _kendali = SesiController(repository: _buatRepository(_pilihan)); _kendali.pulihkan(); }
  void _ganti(String? pilihan) {
    if (pilihan == null || pilihan == _pilihan) return;
    setState(() { _kendali.dispose(); _pilihan = pilihan; _kendali = SesiController(repository: _buatRepository(_pilihan)); });
    _kendali.pulihkan();
  }
  @override void dispose() { _kendali.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Modul 06 Pengayaan • Fase B', theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3567D4)), useMaterial3: true), home: Scaffold(appBar: AppBar(title: const Text('Fase B • Storage & Sesi'), actions: [DropdownButtonHideUnderline(child: DropdownButton<String>(value: _pilihan, items: const [DropdownMenuItem(value: 'Memori', child: Text('Memori')), DropdownMenuItem(value: 'SharedPreferences', child: Text('Prefs')), DropdownMenuItem(value: 'Secure storage', child: Text('Aman'))], onChanged: _ganti))]), body: GerbangSesi(controller: _kendali, form: (_) => LoginPengayaanScreen(controller: _kendali), beranda: (_, sesi) => BerandaPengayaanScreen(controller: _kendali, sesi: sesi))));
}
