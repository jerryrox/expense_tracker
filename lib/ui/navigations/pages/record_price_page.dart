import 'package:expense_tracker/modules/api/create_record/create_record_api.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/ui/components/primitives/bottom_content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/button_with_constraint.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/money_text_field.dart';
import 'package:expense_tracker/ui/components/primitives/page_top_margin.dart';
import 'package:expense_tracker/ui/components/primitives/text_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordPricePage extends StatefulWidget {
  final Category category;

  RecordPricePage({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordPricePageState();
}

class _RecordPricePageState extends State<RecordPricePage> with SnackbarMixin, LoaderMixin {
  double price = 0;

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the category currently selected
  Category get category => widget.category;

  /// Creates a new record based on current state.
  Future createRecord() async {
    final loader = showLoader(context);

    try {
      final api = CreateRecordApi(
        userState.uid,
        category.id,
        price,
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
                Text("Enter the price of this record."),
                MoneyTextField(
                  onChanged: _onPriceChanged,
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
