import 'package:flutter/material.dart';
import 'package:savetify/app_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MyAppView();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: const MyHomePage(),
  //   );
  // }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Demo Home Page'),
//       ),
//       body: const Center(
//         child: Text(
//           'Hello World',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }