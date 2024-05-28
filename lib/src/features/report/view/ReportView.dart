import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:savetify/src/features/expense/model/ExpenseModel.dart';
import 'package:savetify/src/features/invesment/model/InvestmentModel.dart';
import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
import 'package:savetify/src/features/report/model/GraphData.dart';
import 'dart:math';

import 'package:savetify/src/features/report/view_model/ReportViewModel.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key, required this.reportViewModel});

  final ReportViewModel reportViewModel;

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  late ReportViewModel _reportViewModel;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedStartingDate;
  late DateTime _selectedEndingDate;
  late List<PortfolioModel> _selectedPortfolios;

  @override
  void initState() {
    super.initState();
    _reportViewModel = widget.reportViewModel;
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedStartingDate = DateTime.now();
    _selectedEndingDate = DateTime.now();
    _selectedPortfolios = [];
  }

  @override
  void dispose() {
    // clean up when widget is removed
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<Widget> getReports() {
    if (_reportViewModel.length == 0) {
      return [const Text('No reports available')];
    } else {
      List<Widget> reports = [];
      for (var i = 0; i < _reportViewModel.length; i++) {
        reports.add(
          ListTile(
            title: Text(_reportViewModel.getTitle(i)),
            subtitle: Text(_reportViewModel.getDescription(i)),
            tileColor: Colors.grey[300],
            onTap: () => _showReport(i),
          ),
        );
      }
      return reports;
    }
  }

  _showReport(int i) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reportDetailsScreen(
          index: i,
        ),
      ),
    );
  }

  Widget reportDetailsScreen({required int index}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_reportViewModel.getTitle(index)),
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _reportViewModel.getDescription(index),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Starting Date: ${_formatDate(_reportViewModel.getStartingDate(index))}\n"
                        "Ending Date: ${_formatDate(_reportViewModel.getEndingDate(index))}\n"
                        "Creation Date: ${_formatDate(_reportViewModel.getCreationDate(index))}"),
                  ),
                ),
                createInvestmentGraphs(index),
                createExpenseGraphs(index),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget createExpenseGraphs(int index) {
    DateTime startingDate = _reportViewModel.getStartingDate(index);
    DateTime endingDate = _reportViewModel.getEndingDate(index);
    List<ExpenseModel> expenses =
        _reportViewModel.getExpenseForTime(startingDate, endingDate);
    expenses.sort((a, b) => a.date.compareTo(b.date));

    double totalExpenses = 0.0;
    for (var i = 0; i < expenses.length; i++) {
      totalExpenses += expenses[i].amount;
    }

    List<BarChartGroupData> barGroups = [];

    for (var i = 0; i < expenses.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: expenses[i].amount,
            ),
          ],
        ),
      );
    }
    if (barGroups.isEmpty) {
      return const Text("No expenses available");
    }
    return Card(
      elevation: 4,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, right: 32.0, left: 32.0),
              child: BarChart(
                BarChartData(
                  barGroups: [
                    ...barGroups,
                  ],
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      axisNameWidget: Text('Expenses'),
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.transparent,
                      ),
                      top: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 0,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          // ignore: prefer_interpolation_to_compose_strings
                          rod.toY.toString() +
                              '\n' +
                              _formatDate(expenses[groupIndex].date) +
                              '\n' +
                              expenses[groupIndex].category,
                          const TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text("Total Expenses: ${totalExpenses.toStringAsFixed(2)}"),
          ),
        ],
      ),
    );
  }

  _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  _addReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => addReportScreen(),
      ),
    );
  }

  _selectDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }

  Widget createInvestmentGraphs(int reportIndex) {
    List<Widget> graphs = [];
    List<PortfolioModel> portfolios =
        _reportViewModel.getReports[reportIndex].getPortfolios;
    for (var i = 0; i < portfolios.length; i++) {
      List<InvestmentModel> investments = portfolios[i].getInvestments;
      graphs.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            portfolios[i].getPortfolioName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
      for (var j = 0; j < investments.length; j++) {
        List<GraphData> graphData = _reportViewModel.getGraphDataForInvestment(
            reportIndex, portfolios[i].getPortfolioName, investments[j].name);
        List<FlSpot> flSpots = graphData.map((e) => e.spot).toList();
        if (flSpots.isEmpty) {
          continue;
        }
        graphs.add(
          Card(
            elevation: 4,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.7,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, bottom: 16.0, right: 32.0, left: 32.0),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: flSpots,
                            barWidth: 4,
                            isCurved: true,
                            preventCurveOverShooting: true,
                          ),
                        ],
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            axisNameWidget: Text(investments[j].name),
                            sideTitles: const SideTitles(showTitles: false),
                          ),
                          bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: const FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            right: BorderSide(
                              color: Colors.transparent,
                            ),
                            top: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              return LineTooltipItem(
                                // ignore: prefer_interpolation_to_compose_strings
                                touchedSpot.y.toStringAsFixed(2).toString() +
                                    "\n" +
                                    _formatDate(graphData
                                        .elementAt(flSpots.indexOf(FlSpot(
                                            touchedSpot.x, touchedSpot.y)))
                                        .date),
                                const TextStyle(color: Colors.black),
                              );
                            }).toList();
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Net Profit: ${flSpots.last.y - flSpots.first.y}"),
                Text(
                    "ROI: ${((flSpots.last.y - flSpots.first.y) / flSpots.first.y).toStringAsFixed(2)}"),
                Text(
                    "CAGR: ${(pow((flSpots.last.y / flSpots.first.y), (1 / (graphData.last.date.difference(graphData.first.date).inDays / 365))) - 1).toStringAsFixed(2)}"),
              ],
            ),
          ),
        );
      }
    }
    return Column(
      children: graphs,
    );
  }

  Widget addReportScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Report'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
          ),
          TextButton(
            onPressed: () async => _selectedStartingDate = await _selectDate(),
            child: const Text("Select Start Date"),
          ),
          TextButton(
            onPressed: () async => _selectedEndingDate = await _selectDate(),
            child: const Text("Select End Date"),
          ),
          MultiSelectDialogField(
            items: _reportViewModel.getPortfolios().map((e) {
              return MultiSelectItem(e, e.getPortfolioName);
            }).toList(),
            title: const Text("Select Portfolio"),
            buttonText: const Text("Select Portfolio"),
            onConfirm: (results) {
              _selectedPortfolios = results;
            },
          ),
          TextButton(
            onPressed: () => {
              _reportViewModel.addReport(
                _titleController.text,
                _descriptionController.text,
                _selectedStartingDate,
                _selectedEndingDate,
                _selectedPortfolios,
              ),
              Navigator.pop(context),
              setState(() => _reportViewModel.getReports), // refresh the view
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...getReports(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addReport(),
        heroTag: 'addReport',
        tooltip: 'Add Report',
        child: const Icon(Icons.add),
      ),
    );
  }
}
