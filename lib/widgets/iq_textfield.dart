import 'package:flutter/material.dart';

class IQTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final String? Function(String?)? validator;

  const IQTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(labelText: hint, prefixIcon: Icon(icon)),
    );
  }
}
