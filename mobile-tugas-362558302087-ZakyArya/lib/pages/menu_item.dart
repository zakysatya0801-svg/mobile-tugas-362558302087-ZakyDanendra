import 'package:flutter/material.dart';

const Color kBiru = Color(0xFF1E6FD9);

/// Data menu sederhana.
class MenuMakanan {
  final String nama;
  final String harga;
  final String deskripsi;
  final String deskripsiDetail;

  const MenuMakanan({
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.deskripsiDetail,
  });
}

const nasiGoreng = MenuMakanan(
  nama: 'Nasi Goreng',
  harga: 'Rp15.000',
  deskripsi: 'Nasi goreng dengan telur, ayam, dan sayuran.',
  deskripsiDetail:
      'Nasi goreng dengan telur, ayam, dan sayuran. Menu favorit di kantin kampus!',
);

/// Gambar menu. Jika file asset belum ada, tampil placeholder.
class MenuImage extends StatelessWidget {
  final String asset;
  final double height;
  final double radius;
  final BoxFit fit;

  const MenuImage({
    super.key,
    required this.asset,
    required this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        asset,
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          height: height,
          width: double.infinity,
          color: const Color(0xFFFFF3D6),
          alignment: Alignment.center,
          child: Text('🍳', style: TextStyle(fontSize: height * 0.5)),
        ),
      ),
    );
  }
}

AppBar buildAppBar(String title) => AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
      backgroundColor: kBiru,
      foregroundColor: Colors.white,
      elevation: 0,
    );

ButtonStyle get filledStyle => ElevatedButton.styleFrom(
      backgroundColor: kBiru,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
