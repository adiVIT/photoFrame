import 'package:flutter/material.dart';
import 'home.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Splash Screen',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
