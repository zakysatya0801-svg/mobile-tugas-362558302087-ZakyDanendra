import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';
import '../services/auth_api.dart';
import '../services/sesi_memori.dart';
import '../widgets/field_kata_sandi.dart';
import '../widgets/kartu_sesi.dart';

enum StatusAuth { memeriksa, keluar, memproses, masuk, gagal }

class LoginScreen extends StatefulWidget {
  final AuthApi api;
  final SesiMemori sesiMemori;
  final DateTime Function() jam;
  const LoginScreen({super.key, required this.api, required this.sesiMemori, this.jam = DateTime.now});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  StatusAuth _status = StatusAuth.memeriksa;
  String? _pesanGagal;
  SesiPengguna? _sesi;

  @override
  void initState() {
    super.initState();
    _pulihkanSesi();
  }

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  Future<void> _pulihkanSesi() async {
    final tersimpan = widget.sesiMemori.baca();
    if (tersimpan != null && !tersimpan.sudahKedaluwarsa(widget.jam())) {
      if (!mounted) return;
      setState(() { _sesi = tersimpan; _status = StatusAuth.masuk; });
    } else {
      if (tersimpan != null) await widget.sesiMemori.hapus();
      if (!mounted) return;
      setState(() { _sesi = null; _status = StatusAuth.keluar; });
    }
  }

  Future<void> _masuk() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() { _status = StatusAuth.memproses; _pesanGagal = null; });
    try {
      final sesi = await widget.api.masuk(email: _email.text, sandi: _sandi.text);
      await widget.sesiMemori.simpan(sesi);
      if (!mounted) return;
      setState(() { _sesi = sesi; _status = StatusAuth.masuk; _sandi.clear(); });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() { _pesanGagal = '[${e.kode}] ${e.pesan}'; _status = StatusAuth.gagal; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _pesanGagal = 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.'; _status = StatusAuth.gagal; });
    }
  }

  Future<void> _keluar() async {
    await widget.sesiMemori.hapus();
    if (!mounted) return;
    setState(() { _sesi = null; _pesanGagal = null; _email.clear(); _sandi.clear(); _status = StatusAuth.keluar; });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Modul 06 — Login & Session Dasar'), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        body: SafeArea(child: _bangunIsi()),
      );

  Widget _bangunIsi() {
    switch (_status) {
      case StatusAuth.memeriksa:
        return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Memeriksa sesi tersimpan…')]));
      case StatusAuth.masuk:
        final sesi = _sesi;
        return sesi == null ? _bangunForm() : _bangunBeranda(sesi);
      case StatusAuth.keluar:
      case StatusAuth.memproses:
      case StatusAuth.gagal:
        return _bangunForm();
    }
  }

  Widget _bangunForm() {
    final sibuk = _status == StatusAuth.memproses;
    return ListView(padding: const EdgeInsets.all(20), children: [
      const SizedBox(height: 8),
      Icon(Icons.account_circle_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 12),
      const Text('Masuk ke Portal Akademik', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Praktikum Fase A • Simulasi autentikasi lokal', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 24),
      if (_pesanGagal != null) ...[
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer), const SizedBox(width: 8), Expanded(child: Text(_pesanGagal!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)))])),
        const SizedBox(height: 16),
      ],
      Form(key: _formKey, child: Column(children: [
        TextFormField(controller: _email, enabled: !sibuk, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autocorrect: false, enableSuggestions: false, decoration: InputDecoration(labelText: 'Email', hintText: 'nama@contoh.test', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) { if (v == null || v.trim().isEmpty) return 'Email wajib diisi.'; if (!v.trim().contains('@')) return 'Masukkan format email yang benar.'; return null; }),
        const SizedBox(height: 16),
        FieldKataSandi(controller: _sandi, enabled: !sibuk, onSubmitted: (_) => _masuk(), validator: (v) => v == null || v.isEmpty ? 'Kata sandi wajib diisi.' : null),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 48, child: FilledButton.icon(onPressed: sibuk ? null : _masuk, icon: sibuk ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login), label: Text(sibuk ? 'Sedang masuk…' : 'Masuk'))),
      ])),
      const SizedBox(height: 24),
      Card(elevation: 0, color: Theme.of(context).colorScheme.surfaceContainer, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Akun demo', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), const SelectableText('Email: student@trpl.test\nKata sandi: belajar123'), const Divider(height: 24), const Text('Uji respons lain', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('terkunci@trpl.test — akun terkunci (423)\ngangguan@trpl.test — server bermasalah (503)\nEmail atau kata sandi lain — ditolak (401)'), TextButton.icon(onPressed: sibuk ? null : () { _email.text = AuthApi.emailDemo; _sandi.text = AuthApi.sandiDemo; setState(() => _pesanGagal = null); }, icon: const Icon(Icons.edit_outlined), label: const Text('Isi akun demo'))]))),
    ]);
  }

  Widget _bangunBeranda(SesiPengguna sesi) => ListView(padding: const EdgeInsets.all(20), children: [
        const SizedBox(height: 8),
        const Text('Selamat datang!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Login berhasil. Informasi sesi berikut hanya disimpan di memori selama aplikasi berjalan.'),
        const SizedBox(height: 16),
        KartuSesi(sesi: sesi, sekarang: widget.jam(), onKeluar: _keluar),
        const SizedBox(height: 12),
        Text('Catatan: ini API tiruan untuk praktikum, bukan sistem autentikasi sungguhan.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]);
}
