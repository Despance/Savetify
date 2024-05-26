import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:savetify/src/theme/theme.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obsureText = true;
  bool _obsureTextConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SavetifyTheme.lightTheme,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: (constraints.maxWidth >= 1200)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        'lib/src/anim/boarding_anim.json',
                                        width: 400,
                                        height: 400,
                                        fit: BoxFit.fill),
                                    const Text(
                                      'Track your expenses with ease!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Managing your invesments better.',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              buildSignUpField(context, constraints),
                            ],
                          )
                        : buildSignUpField(context, constraints)));
          },
        ),
      ),
    );
  }

  Expanded buildSignUpField(context, constraints) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SignUpBoarding(),
          allTextFields(),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 35),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _signUpWithEmailAndPassword();
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Column allTextFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                icon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obsureText = !_obsureText;
                    });
                  },
                  icon: !_obsureText
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                )),
            obscureText: _obsureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Enter your password again',
                icon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obsureTextConfirm = !_obsureTextConfirm;
                    });
                  },
                  icon: !_obsureTextConfirm
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                )),
            obscureText: _obsureTextConfirm,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _signUpWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/add_details', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}

class SignUpBoarding extends StatelessWidget {
  const SignUpBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.supervised_user_circle,
            size: 250,
          ),
        ),
        SizedBox(height: 32),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Create an account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Start using Savetify for better financial management',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
