import 'package:savetify/src/features/income/model/IncomeModel.dart';
import 'package:savetify/src/features/income/model/IncomeRepository.dart';

class IncomeViewModel{
  IncomeRepository _incomeRepository = IncomeRepository();


  Future<void> getIncomesFromFirebase() async {
    await _incomeRepository.getIncomesFromFirebase();
    _incomeRepository.getIncomes();
  }

  Future<void> setIncomesFromFirebase(IncomeModel incomeModel) async {
    await _incomeRepository.addToFireBase( incomeModel);
  }


  getIncomes() {
    return _incomeRepository.getIncomes();
  }

}