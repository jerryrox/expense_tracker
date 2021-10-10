import 'package:flutter/material.dart';

class ButtonGroup extends StatelessWidget {
  final List<String> selections;
  final int selectedIndex;
  final Function(int) onSelection;

  ButtonGroup(this.selections, {Key key, this.selectedIndex, this.onSelection}) : super(key: key) {
    if (selections == null) {
      throw "Selection list mustn't be null.";
    }
    if (selections.length == 0) {
      throw "Selection list mustn't be empty.";
    }
  }

  /// Event called when one of the selection buttons have been selected.
  void onSelectionButton(int index) {
    if (onSelection != null) {
      onSelection(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _drawSelectionButtons(context),
      ),
    );
  }

  /// Draws the selection buttons for the button group.
  List<Widget> _drawSelectionButtons(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> buttons = [];
    for (int i = 0; i < selections.length; i++) {
      int index = i;
      bool isFirst = i == 0;
      bool isLast = i == selections.length - 1;
      bool isSelected = i == selectedIndex;
      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 6 : 0),
        bottomLeft: Radius.circular(isFirst ? 6 : 0),
        topRight: Radius.circular(isLast ? 6 : 0),
        bottomRight: Radius.circular(isLast ? 6 : 0),
      );
      final onClick = () => onSelectionButton(index);
      buttons.add(Ink(
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.scaffoldBackgroundColor,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onTap: onClick,
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Center(
              child: Text(
                selections[i],
                style: TextStyle(
                  color: isSelected ? theme.scaffoldBackgroundColor : theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return buttons;
  }
}
