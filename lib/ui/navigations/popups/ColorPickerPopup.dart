import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerPopup extends StatefulWidget {
  final Color initialColor;

  ColorPickerPopup({
    Key key,
    this.initialColor,
  }) : super(key: key);

  @override
  _ColorPickerPopupState createState() => _ColorPickerPopupState();
}

class _ColorPickerPopupState extends State<ColorPickerPopup> {
  Color color;

  @override
  void initState() {
    super.initState();

    color = widget.initialColor ?? Colors.white;
  }

  /// Sets the current selected color.
  void setColor(Color color) {
    setState(() => this.color = color);
  }

  /// Closes the popup with the specified return value.
  void closePopup(Color color) {
    Navigator.of(context).pop(color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a color"),
      actions: <Widget>[
        FlatButton(child: Text("Confirm"), onPressed: _onConfirmButton),
        FlatButton(child: Text("Cancel"), onPressed: _onCancelButton),
      ],
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: color,
          onColorChanged: _onColorChanged,
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
          enableAlpha: false,
        ),
      ),
    );
  }

  /// Event called when the current color was changed.
  void _onColorChanged(Color color) {
    setColor(color);
  }

  /// Event called when the confirm button was clicked.
  void _onConfirmButton() {
    closePopup(color);
  }

  /// Event called when the cancel button was clicked.
  void _onCancelButton() {
    closePopup(null);
  }
}
