import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:savetify/src/features/invesment/model/InvestmentModel.dart';
import 'package:savetify/src/features/invesment/model/PortfolioModel.dart';
import 'package:savetify/src/features/report/model/InvestmentData.dart';

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
                AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 3),
                            FlSpot(1, 4),
                            FlSpot(2, 3),
                            FlSpot(3, 5),
                            FlSpot(4, 4),
                            FlSpot(5, 6),
                          ],
                          barWidth: 4,
                          isCurved: true,
                          preventCurveOverShooting: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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

  //TODO: implement method to create tables using the function below for data, then put this in the reportDetailsScreen
  List<FlSpot> getFlSpotForInvestmentData(
      int reportIndex, String portfolioName, String investmentName) {
    InvestmentData investmentData = _reportViewModel
        .getPortfolioInvestmentData(reportIndex, portfolioName)
        .firstWhere((element) => element.name == investmentName);
    InvestmentModel investmentModel = _reportViewModel
        .getPortfolio(reportIndex, portfolioName)
        .getInvestments
        .firstWhere((element) => element.name == investmentName);

    List<FlSpot> flSpots = [];
    int length = investmentData.priceOverTime.length;
    for (int i = 0; i < length; i++) {
      if (investmentModel.dateOfPurchase
          .isAfter(investmentData.priceOverTime[i].date)) {
        flSpots.add(FlSpot(
            investmentData.priceOverTime[i].date
                .difference(investmentModel.dateOfPurchase)
                .inDays
                .toDouble(),
            investmentData.priceOverTime[i].price *
                investmentModel.quantity *
                investmentModel.price));
      }
    }
    return flSpots;
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
