import 'package:expense_tracker/modules/api/createCategory/CreateCategoryApi.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/DialogMixin.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/static/MathUtils.dart';
import 'package:expense_tracker/ui/components/primitives/ColorButton.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:expense_tracker/ui/navigations/popups/ColorPickerPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCreatePopup extends StatefulWidget {
  final String initialName;

  CategoryCreatePopup({
    Key key,
    this.initialName = "",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryCreatePopupState();
}

class _CategoryCreatePopupState extends State<CategoryCreatePopup> with UtilMixin, SnackbarMixin, DialogMixin, LoaderMixin {
  static final int maxNameLength = 12;

  String name;
  Color color;

  TextEditingController inputController = TextEditingController();

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the uid of the current user.
  String get uid => userState.user.value.uid;

  @override
  void initState() {
    super.initState();

    name = widget.initialName;
    color = Color.fromARGB(
      255,
      MathUtils.randomInt(127, 256),
      MathUtils.randomInt(127, 256),
      MathUtils.randomInt(127, 256),
    );

    afterFrameRender(() {
      inputController.text = name;
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  /// Sets the name of the new category.
  void setName(String value) => setState(() => this.name = value);

  /// Creates a new category from current stae.
  Future createCategory() async {
    final loader = showLoader(context);

    try {
      if (name.trim().isEmpty) {
        throw "Please enter a valid name.";
      }

      final api = CreateCategoryApi(uid, color.value, name);
      final category = await api.request();
      closePopup(category);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Starts a new color picker process for the user.
  Future chooseColor() async {
    try {
      final color = await showDialogDefault<Color>(
        context,
        ColorPickerPopup(initialColor: this.color),
      );
      if (color != null) {
        setState(() => this.color = color);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Closes the popup with the specified return value.
  void closePopup(Category category) {
    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new category"),
      actions: [
        FlatButton(child: Text("Create"), onPressed: _onCreateButton),
        FlatButton(child: Text("Cancel"), onPressed: _onCancelButton),
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("1. Set the new category's name"),
            Text("(e.g. Games / Rent / Food / etc...)"),
            TextField(
              controller: inputController,
              maxLength: maxNameLength,
              onChanged: _onNameChanged,
            ),
            SizedBox(height: 20),
            Text("2. Choose a color for the category"),
            SizedBox(height: 5),
            ColorButton(
              color: color,
              size: 40,
              onClick: _onColorButton,
            ),
            SizedBox(height: 20),
            Text("(You can always edit these properties later.)"),
          ],
        ),
      ),
    );
  }

  /// Event called when the create button was clicked.
  void _onCreateButton() {
    createCategory();
  }

  /// Event called when the cancel button was clicked.
  void _onCancelButton() {
    closePopup(null);
  }

  /// Event called when the color button was clicked.
  void _onColorButton() {
    chooseColor();
  }

  /// Event called when the name input value has changed.
  void _onNameChanged(String value) {
    setName(value);
  }
}
