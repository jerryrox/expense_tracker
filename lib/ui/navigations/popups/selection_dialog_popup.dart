import 'package:flutter/material.dart';

class SelectionDialogPopup extends StatefulWidget {
  final String title;
  final String message;
  final List<String> selections;

  SelectionDialogPopup({
    Key key,
    this.title,
    this.message,
    this.selections = const [],
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogPopupState();
}

class _SelectionDialogPopupState extends State<SelectionDialogPopup> {
  /// Hides the popup while resolving with the specified return value.
  void resolveSelection(String value) {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title),
      content: widget.message == null ? null : Text(widget.message),
      actions: widget.selections.map((e) {
        return FlatButton(
          onPressed: () => _onSelectionButton(e),
          child: Text(e),
        );
      }).toList(),
    );
  }

  /// Event called when the selection button was clicked.
  void _onSelectionButton(String selection) {
    resolveSelection(selection);
  }
}
