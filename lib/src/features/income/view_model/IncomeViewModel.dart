import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/income/model/IncomeRepository.dart';

class IncomeViewModel {
  final IncomeRepository _incomeRepository;

  IncomeViewModel({required IncomeRepository incomeRepository})
      : _incomeRepository = incomeRepository;

  Future<void> getIncomesFromFirebase() async {
    await _incomeRepository.getIncomesFromFirebase();
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
