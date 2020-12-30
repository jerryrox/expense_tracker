import 'package:expense_tracker/modules/api/createSpecialBudget/CreateSpecialBudgetApi.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';
import 'package:expense_tracker/modules/models/static/DateFormatter.dart';
import 'package:expense_tracker/ui/components/primitives/MoneyTextField.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialBudgetPopup extends StatefulWidget {
  SpecialBudgetPopup({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpecialBudgetPopupState();
}

class _SpecialBudgetPopupState extends State<SpecialBudgetPopup> with SnackbarMixin, UtilMixin, LoaderMixin {
  double amount = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  UserState get userState => Provider.of<UserState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      setStartDate(DateTime.now());
      setEndDate(DateTime.now());
    });
  }

  /// Saves the currently editing info to the server.
  Future saveBudget() async {
    final loader = showLoader(context);

    try {
      if (amount <= 0) {
        throw "The amount must be greater than 0.";
      }
      if (endDate.isBefore(startDate)) {
        throw "Ending date must be on or later than start date.";
      }

      final api = CreateSpecialBudgetApi(
        userState.uid,
        startDate.toUtc(),
        endDate.toUtc().add(Duration(days: 1)),
        amount,
      );
      final newBudget = await api.request();
      closePopup(newBudget);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Starts a new date range selection process for the user.
  Future selectDates() async {
    try {
      final range = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: startDate, end: endDate),
        firstDate: startDate,
        lastDate: DateTime.utc(DateTime.now().year + 2).subtract(Duration(days: 1)),
        
      );
      if (range != null) {
        setStartDate(range.start);
        setEndDate(range.end);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Sets the start date of the budget.
  void setStartDate(DateTime date) {
    setState(() => this.startDate = DateTime.utc(date.year, date.month, date.day));
  }

  /// Sets the end date of the budget.
  void setEndDate(DateTime date) {
    setState(() => this.endDate = DateTime.utc(date.year, date.month, date.day));
  }

  /// Sets the budget amount.
  void setAmount(String amount) {
    setState(() => this.amount = double.tryParse(amount) ?? 0);
  }

  /// Closes the popup with the specified resolve value.
  void closePopup(SpecialBudget budget) {
    Navigator.of(context).pop(budget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text("Setting up a special budget"),
      actions: [
        FlatButton(
          child: Text("Confirm"),
          onPressed: _onConfirmButton,
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: _onCancelButton,
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select the date periods."),
            SizedBox(height: 5),
            FlatButton(
              onPressed: _onDateButton,
              child: Text(
                "${DateFormatter.yyyymmdd(startDate)} ~ ${DateFormatter.yyyymmdd(endDate)}",
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
            SizedBox(height: 20),
            Text("How much are you planning to use in this period?"),
            SizedBox(height: 5),
            MoneyTextField(
              onChanged: _onAmountInputChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// Event called when the budget amount input value was changed.
  void _onAmountInputChanged(String value) {
    setAmount(value);
  }

  /// Event called when the date select button was clicked.
  void _onDateButton() {
    selectDates();
  }

  /// Event called when the confirm button was clicked.
  void _onConfirmButton() {
    saveBudget();
  }

  /// Event called when the cancel button was clicked.
  void _onCancelButton() {
    closePopup(null);
  }
}
