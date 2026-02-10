import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          title: Text("MODULOS", style: TextStyles.bodyButton),
          centerTitle: true,
        ),
        body: HomeScreen(),
      ),
    );
  }
}
