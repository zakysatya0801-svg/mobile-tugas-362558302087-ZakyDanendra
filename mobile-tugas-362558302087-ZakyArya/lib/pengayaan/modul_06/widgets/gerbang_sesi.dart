import 'package:flutter/material.dart';
import 'package:poliwangi_mobile_starter/modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';

class GerbangSesi extends StatelessWidget {
  final SesiController controller;
  final WidgetBuilder form;
  final Widget Function(BuildContext, SesiPengguna) beranda;
  const GerbangSesi({super.key, required this.controller, required this.form, required this.beranda});
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      switch (controller.status) {
        case StatusSesi.memeriksa:
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        case StatusSesi.masuk:
          final sesi = controller.sesi;
          return sesi == null ? form(context) : beranda(context, sesi);
        case StatusSesi.keluar:
        case StatusSesi.memproses:
        case StatusSesi.gagal:
        case StatusSesi.kedaluwarsa:
          return form(context);
      }
    },
  );
}
