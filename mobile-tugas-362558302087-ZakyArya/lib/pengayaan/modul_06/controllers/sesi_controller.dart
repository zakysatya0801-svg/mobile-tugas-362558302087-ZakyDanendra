import 'package:flutter/foundation.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final SesiRepository repository;
  final AuthApi api;
  final DateTime Function() jam;
  StatusSesi status = StatusSesi.memeriksa;
  SesiPengguna? sesi;
  String? pesan;
  bool _sedangMasuk = false;
  SesiController({required this.repository, AuthApi? api, DateTime Function()? jam}) : api = api ?? const AuthApi(), jam = jam ?? DateTime.now;
  void _ubah(StatusSesi baru, {SesiPengguna? sesiBaru, String? pesanBaru, bool bersihkanPesan = false}) {
    status = baru;
    if (sesiBaru != null || baru == StatusSesi.keluar || baru == StatusSesi.kedaluwarsa) sesi = sesiBaru;
    if (bersihkanPesan) {
      pesan = null;
     } else if (pesanBaru != null) { 
      pesan = pesanBaru; }
    notifyListeners(); 
  }
  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa, bersihkanPesan: true);
    final SesiPengguna? tersimpan = await repository.baca();
    if (tersimpan == null) { _ubah(StatusSesi.keluar, sesiBaru: null); return; }
    if (tersimpan.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(StatusSesi.kedaluwarsa, sesiBaru: null, pesanBaru: 'Sesi Anda sudah berakhir. Silakan masuk kembali.');
      return;
    }
    _ubah(StatusSesi.masuk, sesiBaru: tersimpan);
  }
  Future<void> masuk(String email, String sandi) async {
    if (_sedangMasuk) return;
    _sedangMasuk = true;
    _ubah(StatusSesi.memproses, bersihkanPesan: true);
    try {
      final hasil = await api.masuk(email: email, sandi: sandi);
      await repository.simpan(hasil);
      _ubah(StatusSesi.masuk, sesiBaru: hasil);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesanBaru: e.pesan);
    } catch (_) {
      _ubah(StatusSesi.gagal, pesanBaru: 'Terjadi kesalahan. Silakan coba lagi.');
    } finally { _sedangMasuk = false; }
  }
  Future<void> keluar() async { await repository.hapus(); _ubah(StatusSesi.keluar, sesiBaru: null, bersihkanPesan: true); }
  Future<void> perbaruiSesi({Duration masaBerlaku = const Duration(hours: 2)}) async {
    final SesiPengguna? sekarang = sesi;
    if (sekarang == null) return;
    if (sekarang.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(StatusSesi.kedaluwarsa, sesiBaru: null, pesanBaru: 'Sesi sudah berakhir dan tidak dapat diperbarui.');
      return;
    }
    final SesiPengguna baru = await api.perbaruiSesi(sekarang, masaBerlaku: masaBerlaku);
    await repository.simpan(baru);
    _ubah(StatusSesi.masuk, sesiBaru: baru);
  }
}
