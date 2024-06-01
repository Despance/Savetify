import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';

class InvestmentPieChart extends StatelessWidget {
  final int scaleWidth = 800;
  final List<InvestmentModel> investments;

  InvestmentPieChart({required this.investments});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > scaleWidth) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildReport(constraints),
                ),
              ),
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: _getSections(constraints),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: constraints.maxWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                flex: 1, // Fixed height for smaller screens
                child: PieChart(
                  PieChartData(
                    sections: _getSections(constraints),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40, // Fixed center space radius
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildReport(constraints),
              ),
            ],
          );
        }
      },
    );
  }

  List<PieChartSectionData> _getSections(BoxConstraints constraints) {
    double totalValue =
        investments.fold(0, (sum, item) => sum + double.parse(item.value));
    double radius =
        constraints.maxWidth > scaleWidth ? constraints.maxWidth * 0.05 : 50;
    return investments.map((investment) {
      final double percentage =
          (double.parse(investment.value) / totalValue) * 100;
      return PieChartSectionData(
        color: getRandomColor(),
        value: double.parse(investment.value),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle:
            TextStyle(fontSize: radius * 0.3, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Widget _buildReport(BoxConstraints constraints) {
    double totalValue =
        investments.fold(0, (sum, item) => sum + double.parse(item.value));
    double fontSize = constraints.maxWidth > scaleWidth ? 18 : 14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...investments.map((investment) {
          final double percentage =
              (double.parse(investment.value) / totalValue) * 100;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${investment.name}: \$${investment.value} (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(fontSize: fontSize),
            ),
          );
        }).toList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'Total Value: \$${totalValue.toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
