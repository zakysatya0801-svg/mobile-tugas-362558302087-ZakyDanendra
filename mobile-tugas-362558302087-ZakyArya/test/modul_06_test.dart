import 'package:flutter_test/flutter_test.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/auth_api.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/sesi_memori.dart';

void main() {
  group('SesiPengguna', () {
    test('serialisasi dan nilai cadangan fromJson', () {
      final sesi = SesiPengguna.contoh(sekarang: DateTime(2026, 10, 1));
      expect(SesiPengguna.fromJson(sesi.toJson()).email, sesi.email);
      expect(SesiPengguna.fromJson(<String, dynamic>{}).email, 'tanpa-email');
    });

    test('menghitung sisa waktu dan masa berlaku', () {
      final sekarang = DateTime(2026, 10, 1, 8);
      final sesi = SesiPengguna.contoh(sekarang: sekarang);
      expect(sesi.sisaWaktu(sekarang).inHours, 2);
      expect(sesi.sudahKedaluwarsa(sekarang), isFalse);
      expect(sesi.sudahKedaluwarsa(sekarang.add(const Duration(hours: 3))), isTrue);
    });
  });

  group('AuthApi', () {
    const api = AuthApi(tunda: Duration.zero);
    test('login demo berhasil', () async {
      final sesi = await api.masuk(email: AuthApi.emailDemo, sandi: AuthApi.sandiDemo);
      expect(sesi.email, AuthApi.emailDemo);
      expect(sesi.token, startsWith('dummy.'));
    });

    test('akun terkunci menghasilkan kode 423', () async {
      expect(() => api.masuk(email: AuthApi.emailTerkunci, sandi: 'apa saja'), throwsA(isA<AuthException>().having((e) => e.kode, 'kode', 423)));
    });
  });

  test('SesiMemori menyimpan dan menghapus sesi', () async {
    final memori = SesiMemori();
    final sesi = SesiPengguna.contoh();
    await memori.simpan(sesi);
    expect(memori.baca(), sesi);
    expect(memori.jumlahPenulisan, 1);
    await memori.hapus();
    expect(memori.adaSesi, isFalse);
  });
}
