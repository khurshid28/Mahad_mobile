// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPassword;
                  },
                )
              : null,
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
