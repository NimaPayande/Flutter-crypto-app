import 'package:crypto_app/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          iconTheme: const IconThemeData(color: Colors.white),
          fontFamily: 'poppins',
          textTheme: const TextTheme(
              titleLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              bodyLarge: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white60, fontSize: 14))),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
