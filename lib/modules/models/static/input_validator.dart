import 'package:flutter/services.dart';

class InputValidator {

  InputValidator._();

  static final TextInputFormatter numberFormatter = FilteringTextInputFormatter(RegExp(r"^[0-9]*(\.[0-9]{0,2})?$"), allow: true);
}