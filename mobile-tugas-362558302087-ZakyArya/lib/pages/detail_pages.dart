import 'package:flutter/material.dart';
import 'succes_pages.dart';
import 'menu_item.dart';

class DetailPage extends StatelessWidget {
  final MenuMakanan menu;

  const DetailPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar('Detail Menu'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenuImage(
              asset: 'lib/pages/nasigoreng.jpg',
              height: 220,
            ),
            const SizedBox(height: 16),
            Text(
              menu.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Harga: ${menu.harga}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(menu.deskripsiDetail),
            const SizedBox(height: 20),
            ElevatedButton(
              style: filledStyle,
              // Navigator.pushReplacement(): ganti halaman ini dengan SuccessPage
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SuccessPage(menu: menu)),
              ),
              child: const Text('Pesan Sekarang'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: kBiru,
                side: const BorderSide(color: kBiru),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Navigator.pop(): kembali ke HomePage
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
