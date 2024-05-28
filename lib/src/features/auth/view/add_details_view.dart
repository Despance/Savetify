import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:savetify/src/features/profile/model/user.dart';

class AddDetailsView extends StatefulWidget {
  const AddDetailsView({super.key, this.user});

  final UserModel? user;

  @override
  _AddDetailsViewState createState() => _AddDetailsViewState();
}

class _AddDetailsViewState extends State<AddDetailsView> {
  final _formKey = GlobalKey<FormBuilderState>();

  UserModel? userModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      userModel = widget.user!;
    }
  }

  final User? _user = FirebaseAuth.instance.currentUser;

  addUserToFirestore(User userCredential, Map<String, dynamic> formData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.uid)
          .set({
        'uid': userCredential.uid,
        'email': userCredential.email,
        'date_created': DateTime.now(),
        'name': formData['name'],
        'surname': formData['surname'],
        'investment_profile': formData['investment_profile'],
        'education_level': formData['education_level'],
        'income': formData['income'],
        'expense': formData['expense'],
        'investment_types': formData['investment_types'],
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  String? _alphaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'This field must contain only alphabetic characters';
    }
    return null;
  }

  // Custom validator for required fields
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: constraints.maxWidth <= 1200
                    ? const EdgeInsets.all(16.0)
                    : EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth / 3, vertical: 100.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        userModel != null
                            ? 'Welcome ${userModel!.name}! Please edit in your details'
                            : 'Please fill in your details',
                        style: const TextStyle(fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FormBuilderTextField(
                          name: 'name',
                          initialValue: userModel?.name,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: _alphaValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FormBuilderTextField(
                          name: 'surname',
                          initialValue: userModel?.surname,
                          decoration: const InputDecoration(
                            labelText: 'Surname',
                          ),
                          validator: _alphaValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: dropDownBuilder(
                            'education_level',
                            'Education Level',
                            userModel?.educationLevel,
                            [
                              'Middle School',
                              'High School',
                              'Undergraduate',
                              'Postgraduate',
                              'Doctorate'
                            ],
                            _requiredValidator),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: dropDownBuilder(
                          'investment_profile',
                          'Investment Profile',
                          userModel?.investmentProfile,
                          ['Conservative', 'Moderate', 'Aggressive'],
                          _requiredValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: dropDownBuilder(
                            'income',
                            'Monthly Income',
                            userModel?.income,
                            [
                              'Less than 5000',
                              '5000 - 10000',
                              '10000 - 20000',
                              '20000 - 50000',
                              'More than 50000'
                            ],
                            _requiredValidator),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: dropDownBuilder(
                            'expense',
                            'Monthly Expenses (includes everything)',
                            userModel?.expense,
                            [
                              'Less than 5000',
                              '5000 - 10000',
                              '10000 - 20000',
                              '20000 - 50000',
                              'More than 50000'
                            ],
                            _requiredValidator),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FormBuilderCheckboxGroup(
                          name: 'investment_types',
                          initialValue: userModel?.investmentTypes,
                          decoration: const InputDecoration(
                              labelText: 'Preferred Investment Types'),
                          options: const [
                            FormBuilderFieldOption(value: 'Stocks'),
                            FormBuilderFieldOption(value: 'Bonds'),
                            FormBuilderFieldOption(value: 'Mutual Funds'),
                            FormBuilderFieldOption(value: 'Real Estate'),
                            FormBuilderFieldOption(value: 'Crypto Currency'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            var formData = _formKey.currentState?.value;
                            if (formData != null &&
                                FirebaseAuth.instance.currentUser != null) {
                              setState(() {
                                _isLoading = true;
                              });
                              await addUserToFirestore(_user!, formData)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Details saved successfully! Redirecting to profile page.'),
                                  ),
                                );
                                Navigator.pop(context);
                              });
                            }
                          } else {
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please fill in all the fields.'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  FormBuilderDropdown<String> dropDownBuilder(
      String name,
      String label,
      String? initalValue,
      List<String> items,
      String? Function(String?)? validator) {
    return FormBuilderDropdown(
      name: name,
      initialValue: initalValue,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: validator,
    );
  }
}
