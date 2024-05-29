import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';

class InvestmentPieChart extends StatelessWidget {
  final List<InvestmentModel> investments;

  InvestmentPieChart({required this.investments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _getSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildReport(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    double totalValue =
        investments.fold(0, (sum, item) => sum + double.parse(item.value));
    return investments.map((investment) {
      final double percentage =
          (double.parse(investment.value) / totalValue) * 100;
      return PieChartSectionData(
        color: _getColor(investment.name),
        value: double.parse(investment.value),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  Color _getColor(String name) {
    // Define colors for each investment name
    Map<String, Color> colorMap = {
      'Stocks': Colors.blue,
      'Bonds': Colors.green,
      'Real Estate': Colors.red,
      'Cryptocurrency': Colors.orange,
      'Commodities': Colors.purple,
      // Add more as needed
    };
    return colorMap[name] ?? Colors.grey;
  }

  Widget _buildReport() {
    double totalValue =
        investments.fold(0, (sum, item) => sum + double.parse(item.value));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: investments.map((investment) {
        final double percentage =
            (double.parse(investment.value) / totalValue) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${investment.name}: \$${investment.value} (${percentage.toStringAsFixed(1)}%)',
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
