import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Reportesprincipal extends StatefulWidget {
  const Reportesprincipal({super.key});

  @override
  State<Reportesprincipal> createState() => _ReportesprincipalState();
}

class _ReportesprincipalState extends State<Reportesprincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("REPORTES", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
    ;
  }
}
