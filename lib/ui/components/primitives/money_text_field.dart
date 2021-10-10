import 'package:expense_tracker/modules/models/static/input_validator.dart';
import 'package:flutter/material.dart';

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final InputDecoration decoration;

  const NumberTextField({
    Key key,
    this.controller,
    this.onChanged,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        InputValidator.numberFormatter,
      ],
      onChanged: onChanged,
    );
  }
}
