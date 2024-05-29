import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:savetify/src/features/report/view/InvestmentReportChart.dart';
import 'package:savetify/src/features/report/view_model/ReportViewModel.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  late ReportViewModel reportViewModel;

  _initData() async {
    reportViewModel = ReportViewModel();
    await reportViewModel.updateRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initData(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: Center(child: CircularProgressIndicator()))
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("Report",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)),
                      SizedBox(
                        height: 300,
                        width: 300, 
                        child: InvestmentPieChart(
                            investments: reportViewModel.getInvestments()),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
