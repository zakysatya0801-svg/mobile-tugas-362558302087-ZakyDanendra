import 'package:flutter/material.dart';

class FieldKataSandi extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String)? onSubmitted;
  const FieldKataSandi({super.key, required this.controller, this.validator, this.enabled = true, this.onSubmitted});
  @override
  State<FieldKataSandi> createState() => _FieldKataSandiState();
}

class _FieldKataSandiState extends State<FieldKataSandi> {
  bool _terlihat = false;
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        enabled: widget.enabled,
        obscureText: !_terlihat,
        onFieldSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Kata sandi',
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            tooltip: _terlihat ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi',
            onPressed: widget.enabled ? () => setState(() => _terlihat = !_terlihat) : null,
            icon: Icon(_terlihat ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      );
}
