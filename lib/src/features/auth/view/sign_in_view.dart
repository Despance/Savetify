import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Padding(
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
                                Lottie.asset('lib/src/anim/boarding_anim.json',
                                    width: 400, height: 400, fit: BoxFit.fill),
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
                          buildSignInColumn(context, constraints),
                        ],
                      )
                    : buildSignInColumn(context, constraints)),
          ),
        );
      },
    );
  }

  Expanded buildSignInColumn(BuildContext context, BoxConstraints constraints) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (constraints.maxWidth < 1200)
              ? Lottie.asset('lib/src/anim/boarding_anim.json',
                  width: 400, height: 400, fit: BoxFit.fill)
              : const SizedBox(
                  height: 10,
                ),
          const WelcomeScreen(),
          allTextFields(),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
              onPressed: () {/* Handle 'Forgot Password' action */},
              child: const Text('Forgot Password?'),
            ),
          ]),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _signInWithEmailAndPassword();
              }
            },
            child: const Text('Sign In'),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: DividerWithText(text: 'or'),
          ),
          SignInButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            Buttons.google,
            onPressed: _signInWithGoogle,
          ),
          const SizedBox(height: 20), // Add spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('Sign Up'),
              ),
            ],
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
      ],
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    var userCredenitals;
    try {
      if (kIsWeb) {
        userCredenitals =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else if (Platform.isWindows) {
        userCredenitals = await _windowsSignInWithGoogle();
      } else {
        userCredenitals = await FirebaseAuth.instance
            .signInWithProvider(GoogleAuthProvider());
      }
    } catch (e) {
      SnackBar(content: Text('Error signing in with Google: $e'));
    }
    if (userCredenitals != null) {
      if (userCredenitals.additionalUserInfo!.isNewUser) {
        Navigator.pushNamed(context, '/add_details');
      }
    }
    return userCredenitals;
  }

  Future<UserCredential> _windowsSignInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> _signInWithEmailAndPassword() async {
    var userCredenitals =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    return userCredenitals;
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Welcome to Savetify!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Start managing your finance faster and better.',
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

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    this.text = '',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            indent: 20.0,
            endIndent: 10.0,
            thickness: 1,
          ),
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.blueGrey),
        ),
        const Expanded(
          child: Divider(
            indent: 10.0,
            endIndent: 20.0,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
