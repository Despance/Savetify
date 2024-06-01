import 'package:savetify/src/features/expense/model/expense_model.dart';
import 'package:savetify/src/features/expense/model/expense_repository.dart';
import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/income/model/IncomeRepository.dart';
import 'package:savetify/src/features/investment/model/InvestmentModel.dart';
import 'package:savetify/src/features/investment/model/InvestmentRepository.dart';

class ReportRepository {
  List<InvestmentModel> investments = [];
  List<IncomeModel> incomes = [];
  List<ExpenseModel> expenses = [];

  updateRepo() async {
    investments = await InvestmentModelRepository().getInvestmentModels();
    await IncomeRepository().getIncomesFromFirebase();
    incomes = IncomeRepository().getIncomes();
    await ExpenseRepository().getExpensesFromFirebase();
    expenses = ExpenseRepository().getExpenses();
  }

  List<InvestmentModel> getInvestments() {
    return investments;
  }

  List<IncomeModel> getIncomes() {
    return incomes;
  }

  List<ExpenseModel> getExpenses() {
    return expenses;
  }
}
