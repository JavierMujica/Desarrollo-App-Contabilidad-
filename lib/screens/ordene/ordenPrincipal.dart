import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Ordenprincipal extends StatefulWidget {
  const Ordenprincipal({super.key});

  @override
  State<Ordenprincipal> createState() => _OrdenprincipalState();
}

class _OrdenprincipalState extends State<Ordenprincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("ORDEN", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
  }
}
