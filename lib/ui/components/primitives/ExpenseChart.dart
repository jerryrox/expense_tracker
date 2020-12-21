import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChart extends StatelessWidget {
  final List<PieChartSectionData> Function(double) dataFunction;
  
  ExpenseChart({
    Key key,
    this.dataFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              centerSpaceRadius: 0,
              sections: dataFunction(constraints.maxWidth),
            ),
          ),
        );
      },
    );
  }
}
