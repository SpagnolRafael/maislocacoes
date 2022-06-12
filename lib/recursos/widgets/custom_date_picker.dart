import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function() onTap;
  const CustomDatePicker(
      {Key? key,
      required this.controller,
      required this.label,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.date_range_outlined),
        contentPadding: const EdgeInsets.fromLTRB(32, 8, 20, 16),
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
