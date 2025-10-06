import 'package:e_wallet_uts/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "E-Wallet",
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const Splash(),
    );
  }
}
