import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savetify/src/features/auth/view/add_details_view.dart';
import 'package:savetify/src/features/auth/view/auth_view.dart';
import 'package:savetify/src/features/profile/model/user.dart';
import 'package:savetify/src/features/profile/view/risk_profile_chart.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      if (!kIsWeb) {
        if (Platform.isWindows) {
          await GoogleSignIn().signOut();
        }
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthView()),
          (route) => false);
    } catch (e) {
      print('Sign out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
  }

  Future<UserModel> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    UserModel userModel = UserModel.fromFirestore(doc);
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()));
            }

            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Hello ${snapshot.data?.name} !',
                        style: const TextStyle(fontSize: 48)),
                    if (snapshot.data != null)
                      RiskProfileChart(user: snapshot.data!),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDetailsView(
                                      user: snapshot.data,
                                    )));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Edit your Profile',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _signOut(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sign out', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          future: getUser(),
        ),
      ),
    );
  }
}
