import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/profile/model/user.dart';

class CircularRiskBarGraph extends StatelessWidget {
  final UserModel user;

  const CircularRiskBarGraph({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Profile Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: RiskProfileChart(user: user),
        ),
      ),
    );
  }
}

class RiskProfileChart extends StatelessWidget {
  final UserModel user;

  const RiskProfileChart({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final profileScore = _calculateProfileScore(user);

    return Column(
      children: [
        SizedBox(
          height: 400,
          width: 400,
          child: PieChart(
            PieChartData(
              sections: _buildSections(profileScore),
              centerSpaceRadius: 60,
              sectionsSpace: 4,
            ),
          ),
        ),
        Text(
          'Risk Profile: ${user.investmentProfile}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
        ),
        Text(
          'Risk Score: ${profileScore.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  double _calculateProfileScore(UserModel user) {
    final educationScores = {
      'Middle School': 1.0,
      'High School': 2.0,
      'Undergraduate': 3.0,
      'Postgraduate': 4.0,
      'Doctorate': 5.0,
    };

    final incomeScores = {
      'Less than 5000': 1.0,
      '5000 - 10000': 2.0,
      '10000 - 20000': 3.0,
      '20000 - 50000': 4.0,
      'More than 50000': 5.0,
    };

    final expenseScores = {
      'Less than 5000': 1.0,
      '5000 - 10000': 2.0,
      '10000 - 20000': 3.0,
      '20000 - 50000': 4.0,
      'More than 50000': 5.0,
    };

    final profileScores = {
      'Conservative': 1.0,
      'Moderate': 2.0,
      'Aggressive': 3.0,
    };

    double educationScore = educationScores[user.educationLevel] ?? 1.0;
    double incomeScore = incomeScores[user.income] ?? 1.0;
    double expenseScore = expenseScores[user.expense] ?? 1.0;
    double profileScore = profileScores[user.investmentProfile] ?? 1.0;

    // Combine the scores with different weights if necessary
    double totalScore =
        (educationScore + incomeScore - expenseScore) / profileScore;
    return totalScore;
  }

  List<PieChartSectionData> _buildSections(double profileScore) {
    return List.generate(3, (index) {
      final isTouched = index == (profileScore / 6).round();
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

      switch (index) {
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 1,
            title: 'Safe',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: 1,
            title: 'Normal',
            radius: radius,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: 1,
            title: 'Risky',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        default:
          throw Error();
      }
    });
  }
}
