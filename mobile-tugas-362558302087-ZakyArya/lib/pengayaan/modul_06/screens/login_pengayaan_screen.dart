import 'package:flutter/material.dart';
import 'package:poliwangi_mobile_starter/modul_06/services/auth_api.dart';
import '../controllers/sesi_controller.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;
  const LoginPengayaanScreen({super.key, required this.controller});
  @override State<LoginPengayaanScreen> createState() => _LoginPengayaanScreenState();
}
class _LoginPengayaanScreenState extends State<LoginPengayaanScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: AuthApi.emailDemo);
  final _sandi = TextEditingController(text: AuthApi.sandiDemo);
  @override void dispose() { _email.dispose(); _sandi.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Fase B • Login pengayaan')), body: AnimatedBuilder(animation: widget.controller, builder: (context, _) => ListView(padding: const EdgeInsets.all(20), children: [
    const Icon(Icons.lock_outline, size: 56), const SizedBox(height: 12), Text('Masuk untuk memulihkan sesi', style: Theme.of(context).textTheme.headlineSmall),
    const Text('Sesi akan disimpan melalui repository yang dipilih.'),
    if (widget.controller.pesan != null) Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(widget.controller.pesan!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
    Form(key: _form, child: Column(children: [TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v == null || !v.contains('@') ? 'Masukkan email yang valid.' : null), TextFormField(controller: _sandi, obscureText: true, decoration: const InputDecoration(labelText: 'Kata sandi'), validator: (v) => v == null || v.length < 8 ? 'Kata sandi minimal 8 karakter.' : null), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton(onPressed: widget.controller.status == StatusSesi.memproses ? null : () { if (_form.currentState!.validate()) widget.controller.masuk(_email.text, _sandi.text); }, child: Text(widget.controller.status == StatusSesi.memproses ? 'Memproses…' : 'Masuk')))])),
    const SizedBox(height: 10), const Text('Demo: student@trpl.test / belajar123'),
  ])));
}
