import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/sesi_memori.dart';
import 'sesi_repository.dart';

class MemoriSesiRepository implements SesiRepository {
  final SesiMemori memori;
  MemoriSesiRepository(this.memori);
  @override String get nama => 'Memori';
  @override String get keterangan => 'Sesi hanya hidup selama aplikasi berjalan.';
  @override bool get bertahanSetelahRestart => false;
  @override Future<SesiPengguna?> baca() async => memori.baca();
  @override Future<void> simpan(SesiPengguna sesi) => memori.simpan(sesi);
  @override Future<void> hapus() => memori.hapus();
  @override Future<bool> adaSesi() async => memori.adaSesi;
  @override Future<String?> intipMentah() async => null;
}
