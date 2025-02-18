import 'package:flutter/material.dart';
import 'package:last_quiz/login.dart';
import 'package:last_quiz/home.dart';
import 'package:last_quiz/tienda/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePagearticles(),
        '/huella': (context) => HomePageHuella()
      },
    );
  }
}
