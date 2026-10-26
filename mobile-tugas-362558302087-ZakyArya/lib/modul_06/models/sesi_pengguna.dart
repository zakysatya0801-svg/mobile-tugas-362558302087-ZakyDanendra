class SesiPengguna {
  final String token;
  final String email;
  final String nama;
  final String peran;
  final String masukPada;
  final String kedaluwarsaPada;

  const SesiPengguna({
    required this.token,
    required this.email,
    required this.nama,
    required this.peran,
    required this.masukPada,
    required this.kedaluwarsaPada,
  });

  factory SesiPengguna.fromJson(Map<String, dynamic> json) => SesiPengguna(
        token: json['token'] as String? ?? '',
        email: json['email'] as String? ?? 'tanpa-email',
        nama: json['nama'] as String? ?? 'Pengguna',
        peran: json['peran'] as String? ?? 'mahasiswa',
        masukPada: json['masukPada'] as String? ?? '1970-01-01T00:00:00.000',
        kedaluwarsaPada: json['kedaluwarsaPada'] as String? ?? '1970-01-01T00:00:00.000',
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'email': email,
        'nama': nama,
        'peran': peran,
        'masukPada': masukPada,
        'kedaluwarsaPada': kedaluwarsaPada,
      };

  Duration sisaWaktu(DateTime sekarang) {
    final batas = DateTime.tryParse(kedaluwarsaPada);
    if (batas == null) return Duration.zero;
    final sisa = batas.difference(sekarang);
    return sisa.isNegative ? Duration.zero : sisa;
  }

  bool sudahKedaluwarsa(DateTime sekarang) {
    final batas = DateTime.tryParse(kedaluwarsaPada);
    return batas == null || !batas.isAfter(sekarang);
  }

  bool get kedaluwarsa => sudahKedaluwarsa(DateTime.now());

  SesiPengguna copyWith({String? token, String? email, String? nama, String? peran, String? masukPada, String? kedaluwarsaPada}) => SesiPengguna(
        token: token ?? this.token,
        email: email ?? this.email,
        nama: nama ?? this.nama,
        peran: peran ?? this.peran,
        masukPada: masukPada ?? this.masukPada,
        kedaluwarsaPada: kedaluwarsaPada ?? this.kedaluwarsaPada,
      );

  static String labelPeran(String peran) => switch (peran) {
        'dosen' => 'Dosen',
        'mahasiswa' => 'Mahasiswa',
        _ => 'Pengguna',
      };

  static SesiPengguna contoh({DateTime? sekarang}) {
    final mulai = sekarang ?? DateTime(2026, 9, 21, 8);
    return SesiPengguna(token: 'dummy.contoh.trpl', email: 'student@trpl.test', nama: 'Mahasiswa TRPL', peran: 'mahasiswa', masukPada: mulai.toIso8601String(), kedaluwarsaPada: mulai.add(const Duration(hours: 2)).toIso8601String());
  }

  @override
  String toString() => 'SesiPengguna(email: $email, peran: $peran, kedaluwarsaPada: $kedaluwarsaPada)';
}
