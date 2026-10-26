import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'fase_b_sesi_pengguna';
  final Future<SharedPreferences> _prefs;
  PrefsSesiRepository({Future<SharedPreferences>? prefs}) : _prefs = prefs ?? SharedPreferences.getInstance();
  @override String get nama => 'SharedPreferences';
  @override String get keterangan => 'Bertahan setelah restart, tetapi token dapat dibaca melalui API preferensi biasa.';
  @override bool get bertahanSetelahRestart => true;
  @override Future<SesiPengguna?> baca() async {
    final raw = (await _prefs).getString(kunciSesi);
    if (raw == null) return null;
    try { return SesiPengguna.fromJson(jsonDecode(raw) as Map<String, dynamic>); } catch (_) { return null; }
  }
  @override Future<void> simpan(SesiPengguna sesi) async => (await _prefs).setString(kunciSesi, jsonEncode(sesi.toJson()));
  @override Future<void> hapus() async => (await _prefs).remove(kunciSesi);
  @override Future<bool> adaSesi() async => (await baca()) != null;
  @override Future<String?> intipMentah() async {
    final prefs = await _prefs;
    final raw = prefs.getString(kunciSesi);
    if (raw == null) return null;
    try { return SesiPengguna.fromJson(jsonDecode(raw) as Map<String, dynamic>).token; } catch (_) { return raw; }
  }
}
