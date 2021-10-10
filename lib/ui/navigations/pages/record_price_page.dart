import 'package:expense_tracker/modules/api/create_record/create_record_api.dart';
import 'package:expense_tracker/modules/dependencies/prefs.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
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

class _RecordPricePageState extends State<RecordPricePage> with SnackbarMixin, LoaderMixin, UtilMixin {
  double price = 0;
  double conversionRate = 1;

  TextEditingController conversionInput = TextEditingController(text: "1");

  UserState get userState => Provider.of<UserState>(context, listen: false);
  Prefs get prefs => Provider.of<Prefs>(context, listen: false);

  /// Returns the category currently selected
  Category get category => widget.category;

  /// Returns the final price of the record.
  double get finalPrice => (price * conversionRate * 100).truncateToDouble() / 100;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      conversionRate = prefs.conversionRate;
      conversionInput.text = conversionRate.toString();
    });
  }

  /// Creates a new record based on current state.
  Future createRecord() async {
    final finalPrice = this.finalPrice;
    if(finalPrice <= 0) {
      showSnackbar(context, "Please enter a valid price and conversion rate.");
      return;
    }

    final loader = showLoader(context);

    try {
      prefs.conversionRate = conversionRate;

      final api = CreateRecordApi(
        userState.uid,
        category.id,
        finalPrice,
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
    setState(() => price = parsedPrice);
  }

  /// Sets the rate in which the entered price is converted to the final price.
  void setConversionRate(String value) {
    double parsed = double.tryParse(value) ?? 0;
    setState(() => conversionRate = parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record price"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageTopMargin(),
                const Text("Enter the price of this record."),
                NumberTextField(
                  onChanged: _onPriceChanged,
                  decoration: const InputDecoration(
                    labelText: "Price",
                  ),
                ),
                const SizedBox(height: 8),
                NumberTextField(
                  controller: conversionInput,
                  onChanged: _onConversionChanged,
                  decoration: const InputDecoration(
                    labelText: "Conversion rate",
                  ),
                ),
                const SizedBox(height: 16),
                _drawFinalAmount(),
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

  Widget _drawFinalAmount() {
    final finalPrice = this.finalPrice;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Final price"),
        Text(
          "\$$finalPrice",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Event called when the price input value has changed.
  void _onPriceChanged(String value) {
    setPrice(value);
  }
  
  void _onConversionChanged(String value) {
    setConversionRate(value);
  }

  /// Event called when the record button was clicked.
  void _onRecordButton() {
    createRecord();
  }
}
