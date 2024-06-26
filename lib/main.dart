import 'package:flutter/material.dart';
// import 'package:sidoktan/Auth/login_or_register.dart';
// import 'package:sidoktan/Auth/login_or_register.dart';
import 'package:sidoktan/pages/nav.dart';
// import 'package:sidoktan/pages/scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B5CDB)),
        fontFamily: "DMSans",
      ),
      home: const Nav(),
    );
  }
}
