import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String investmentProfile;
  final String educationLevel;
  final String income;
  final String expense;
  final List<String> investmentTypes;

  UserModel(
      {required this.id,
      required this.name,
      required this.surname,
      required this.email,
      required this.investmentProfile,
      required this.educationLevel,
      required this.income,
      required this.expense,
      required this.investmentTypes});

  static UserModel fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    var id = data['uid'];
    var name = data['name'];
    var surname = data['surname'];
    var email = data['email'];
    var investmentProfile = data['investment_profile'];
    var educationLevel = data['education_level'];
    var income = data['income'];
    var expense = data['expense'];
    var investmentTypes = List<String>.from(data['investment_types']);

    return UserModel(
        id: id,
        name: name,
        surname: surname,
        email: email,
        investmentProfile: investmentProfile,
        educationLevel: educationLevel,
        income: income,
        expense: expense,
        investmentTypes: investmentTypes);
  }
}
