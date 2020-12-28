import 'package:expense_tracker/modules/api/createRecord/CreateRecordApi.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/NewRecordFormData.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecordPricePage extends StatefulWidget {
  final NewRecordFormData formData;

  RecordPricePage({
    Key key,
    this.formData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordPricePageState();
}

class _RecordPricePageState extends State<RecordPricePage> with SnackbarMixin {
  double price = 0;

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the uid of the current user.
  String get uid => userState.user.value.uid;

  /// Returns the item currently selected
  Item get item => widget.formData.item;

  /// Retursn the list of tags currently selected.
  List<Tag> get tags => widget.formData.tags;

  /// Creates a new record based on current state.
  Future createRecord() async {
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
      body: FilledBox(
        child: ContentPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text("Enter the price of the item."),
              TextField(
                onChanged: _onPriceChanged,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r"^[0-9]*(\.[0-9]{0,2})?$"), allow: true),
                ],
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
              Expanded(child: Container()),
              BottomContentPadding(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                  ),
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
