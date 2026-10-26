import 'package:flutter/material.dart';
import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;
  const PapanDiagnostikPenyimpanan({super.key, required this.repository});
  @override State<PapanDiagnostikPenyimpanan> createState() => _PapanDiagnostikPenyimpananState();
}
class _PapanDiagnostikPenyimpananState extends State<PapanDiagnostikPenyimpanan> {
  String? _hasilIntip;
  bool _sudahMengintip = false;
  bool _sedangMengintip = false;
  Future<void> _intip() async {
    setState(() => _sedangMengintip = true);
    final String? hasil = await widget.repository.intipMentah();
    if (!mounted) return;
    setState(() { _hasilIntip = hasil; _sudahMengintip = true; _sedangMengintip = false; });
  }
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Papan diagnostik • ${widget.repository.nama}', style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 6), Text(widget.repository.keterangan),
    const SizedBox(height: 10), FilledButton.icon(onPressed: _sedangMengintip ? null : _intip, icon: const Icon(Icons.visibility_outlined), label: Text(_sedangMengintip ? 'Memeriksa…' : 'Intip token melalui API')),
    if (_sudahMengintip) SelectableText(_hasilIntip == null ? 'Tidak ada nilai mentah yang tersedia melalui adapter ini.' : 'Nilai yang dikembalikan API:\n$_hasilIntip'),
    const SizedBox(height: 8), const Text('Catatan: demo batas API, bukan bukti forensik isi disk atau jaminan keamanan perangkat produksi.', style: TextStyle(fontSize: 12)),
  ])));
}
