import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/home.dart';
import 'package:flutter/material.dart';

class Facturacionprincipal extends StatefulWidget {
  const Facturacionprincipal({super.key});

  @override
  State<Facturacionprincipal> createState() => _FacturacionprincipalState();
}

class _FacturacionprincipalState extends State<Facturacionprincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text("FACTURACION", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: HomeScreen(),
    );
  }
}
