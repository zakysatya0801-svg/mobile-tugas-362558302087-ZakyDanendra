import 'dart:convert';
import '../storage/penyimpanan_aman.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'fase_b_sesi_pengguna';
  final PenyimpananAman penyimpanan;
  AmanSesiRepository(this.penyimpanan);
  @override String get nama => 'Secure storage';
  @override String get keterangan => 'Menggunakan API secure storage; perlindungan aktual mengikuti platform dan konfigurasi.';
  @override bool get bertahanSetelahRestart => true;
  @override Future<SesiPengguna?> baca() async {
    final raw = await penyimpanan.baca(kunciSesi);
    if (raw == null) return null;
    try { return SesiPengguna.fromJson(jsonDecode(raw) as Map<String, dynamic>); } catch (_) { return null; }
  }
  @override Future<void> simpan(SesiPengguna sesi) => penyimpanan.tulis(kunciSesi, jsonEncode(sesi.toJson()));
  @override Future<void> hapus() => penyimpanan.hapus(kunciSesi);
  @override Future<bool> adaSesi() async => (await baca()) != null;
  @override Future<String?> intipMentah() => penyimpanan.bacaMentah(kunciSesi);
}
