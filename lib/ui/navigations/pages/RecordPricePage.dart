import 'package:expense_tracker/modules/api/createRecord/CreateRecordApi.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/modules/models/static/InputValidator.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonWidthConstraint.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/PageTopMargin.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecordPricePage extends StatefulWidget {
  final Item item;
  final List<Tag> tags;

  RecordPricePage({
    Key key,
    this.item,
    this.tags,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordPricePageState();
}

class _RecordPricePageState extends State<RecordPricePage> with SnackbarMixin, LoaderMixin {
  double price = 0;

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the uid of the current user.
  String get uid => userState.user.value.uid;

  /// Returns the item currently selected
  Item get item => widget.item;

  /// Retursn the list of tags currently selected.
  List<Tag> get tags => widget.tags;

  /// Creates a new record based on current state.
  Future createRecord() async {
    final loader = showLoader(context);

    try {
      final api = CreateRecordApi(
        uid,
        item.id,
        price,
        tags.map((e) => e.id).toList(),
      );
      await api.request();

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Sets the price of the record.
  void setPrice(String priceString) {
    double parsedPrice = double.tryParse(priceString) ?? 0;
    setState(() => this.price = parsedPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record price"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageTopMargin(),
                Text("Enter the price of the item."),
                TextField(
                  onChanged: _onPriceChanged,
                  inputFormatters: [InputValidator.numberFormatter],
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                ),
                Expanded(child: Container()),
                BottomContentPadding(
                  child: ButtonWidthConstraint(
                    child: TextRoundedButton(
                      "Confirm record",
                      onClick: _onRecordButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Event called when the price input value has changed.
  void _onPriceChanged(String value) {
    setPrice(value);
  }

  /// Event called when the record button was clicked.
  void _onRecordButton() {
    createRecord();
  }
}
