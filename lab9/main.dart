import 'package:flutter/material.dart';
import 'widgets/first_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio 9',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstView(),
    );
  }
}