import 'package:flutter/material.dart';
import 'detail_pages.dart';
import 'menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const menu = nasiGoreng;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar('Kantin Kampus'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MenuImage(
              asset: 'lib/pages/nasigoreng.png',
              height: 220,
              radius: 0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              menu.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              menu.harga,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(menu.deskripsi, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              style: filledStyle,
              // Navigator.push(): buka halaman detail menu
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailPage(menu: menu)),
              ),
              child: const Text('Lihat Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
