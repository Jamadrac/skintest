// lib/main.dart
import 'package:flutter/material.dart';
import 'package:skintest/models/screens/Form3Screen.dart';

void main() {
  runApp(const SkinAssessmentApp());
}

class SkinAssessmentApp extends StatelessWidget {
  const SkinAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Assessment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      home: const Form3Screen(),
    );
  }
}
