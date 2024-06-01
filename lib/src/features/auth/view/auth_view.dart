import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savetify/src/features/auth/view/sign_in_view.dart';
import 'package:savetify/src/features/home/view/home_screen.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isAuth = false;
  String title = 'null';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isAuth = false;
          title = 'null';
        });
      } else {
        setState(() {
          isAuth = true;
          title = user.email!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isAuth ? const LoginPage() : const HomeScreen();
  }
}
