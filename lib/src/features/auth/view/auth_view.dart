import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savetify/app_view.dart';
import 'package:savetify/src/features/auth/view/sign_in_view.dart';
import 'package:savetify/src/features/profile/view/profile_view.dart';

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

  Widget _homePageView(String title) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello $title !'),
            ElevatedButton(
              onPressed: () {
                GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !isAuth ? const LoginPage() : const MyAppView();
  }
}
