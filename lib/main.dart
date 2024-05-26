import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:savetify/app_view.dart';
import 'package:savetify/src/features/auth/view/auth_view.dart';
import 'package:savetify/src/theme/theme.dart';
import 'src/core/firebase_options.dart';
import 'src/features/auth/view/sign_in_view.dart';
import 'src/features/auth/view/sign_up_view.dart';

void main() {
  if (!kIsWeb) {
    GoogleSignInDart.register(
        clientId:
            '974680472249-c7tq9sh5jt051hilshq0c3cv2ag8jqma.apps.googleusercontent.com');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error initializing Firebase'),
            );
          }

          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
            },
            theme: ThemeData.light(),
            builder: (context, child) {
              final Brightness systemBrightness =
                  MediaQuery.of(context).platformBrightness;

              final ThemeMode themeMode = systemBrightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light;

              return MaterialApp(
                title: 'Flutter Demo',
                theme: SavetifyTheme.lightTheme,
                darkTheme: SavetifyTheme.darkTheme,
                themeMode: themeMode,
                home: const MyAppView(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        });
  }
}
