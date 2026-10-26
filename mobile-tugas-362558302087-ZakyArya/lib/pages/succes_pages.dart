import 'package:flutter/material.dart';
import 'menu_item.dart';

class SuccessPage extends StatelessWidget {
  final MenuMakanan menu;

  const SuccessPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar('Pesanan'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF34A853),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pesanan Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${menu.nama} sedang diproses.\nTerima kasih telah memesan\ndi Kantin Kampus.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: filledStyle,
              // Navigator.pop(): kembali ke HomePage
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali ke Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
