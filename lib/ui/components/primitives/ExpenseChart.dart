import 'package:expense_tracker/modules/models/ExpenseChartData.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpenseChart extends StatelessWidget {
  final List<ExpenseChartData> data;

  /// Returns whether the chart data is not empty.
  bool get hasData => data != null && data.isNotEmpty;

  ExpenseChart({
    Key key,
    this.data,
  }) : super(key: key);

  List<Color> getColors() {
    return data.map((e) => e.color).toList();
  }

  Map<String, double> getDataMap() {
    Map<String, double> map = {};
    for(final d in data) {
      map[d.label] = d.value;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _drawChartContent(constraints);
      },
    );
  }

  /// Draws the inner content of the chart container.
  Widget _drawChartContent(BoxConstraints constraints) {
    if(hasData) {
      return PieChart(
        dataMap: getDataMap(),
        chartRadius: constraints.maxWidth / 2,
        colorList: getColors(),
        chartType: ChartType.disc,
        legendOptions: LegendOptions(
          showLegends: false,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 2,
        ),
        formatChartValues: (double value) => "\$${value.toStringAsFixed(2)}",
      );
    }

    return Center(
      child: Text(
        "There are no expense data for this date range."
      ),
    );
  }
}
