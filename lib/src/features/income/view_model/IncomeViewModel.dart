import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/income/model/IncomeRepository.dart';

class IncomeViewModel {
  IncomeRepository _incomeRepository = IncomeRepository();

  Future<void> getIncomesFromFirebase() async {
    await _incomeRepository.getIncomesFromFirebase();
    _incomeRepository.getIncomes();
  }

  Future<void> addIncomesToFirebase(IncomeModel incomeModel) async {
    await _incomeRepository.addToFireBase(incomeModel);
  }

  double getTotalIncome() {
    double totalIncome = 0;
    _incomeRepository.getIncomes().forEach((element) {
      totalIncome += element.amount;
    });
    return totalIncome;
  }

  void deleteIncomeFromFirebase(IncomeModel incomeModel) async {
    await _incomeRepository.deleteIncomeFromFirebase(incomeModel);
    _incomeRepository.getIncomes();
  }

  getIncomes() {
    return _incomeRepository.getIncomes();
  }
}
