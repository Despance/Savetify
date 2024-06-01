import 'package:savetify/src/features/expense/model/expense_model.dart';
import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/report/model/ReportRepository.dart';

class ReportViewModel {
  ReportRepository reportRepository = ReportRepository();

  Future<void> updateRepo() async {
    await reportRepository.updateRepo();
  }

  List<InvestmentModel> getInvestments() {
    return reportRepository.getInvestments();
  }

  double getTotalInvestment() {
    double totalInvestment = 0;
    reportRepository.getInvestments().forEach((element) {
      totalInvestment += double.parse(element.value);
    });
    return totalInvestment;
  }

  List<IncomeModel> getIncomes() {
    return reportRepository.getIncomes();
  }

  double getTotalIncome() {
    double totalIncome = 0;
    reportRepository.getIncomes().forEach((element) {
      totalIncome += element.amount;
    });
    return totalIncome;
  }

  List<ExpenseModel> getExpenses() {
    return reportRepository.getExpenses();
  }

  double getTotalExpense() {
    double totalExpense = 0;
    reportRepository.getExpenses().forEach((element) {
      totalExpense += element.amount;
    });
    return totalExpense;
  }
}
