import 'package:flutter/material.dart';

class Bindable<T> extends ValueNotifier<T> {

  Bindable(T value) : super(value);
}