import 'package:expense_tracker/modules/models/static/InputValidator.dart';
import 'package:flutter/material.dart';

class MoneyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  
  MoneyTextField({Key key, this.controller, this.onChanged}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
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