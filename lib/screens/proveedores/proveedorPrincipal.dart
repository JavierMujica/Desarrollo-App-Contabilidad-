import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Proveedorprincipal extends StatefulWidget {
  const Proveedorprincipal({super.key});

  @override
  State<Proveedorprincipal> createState() => _ProveedorprincipalState();
}

class _ProveedorprincipalState extends State<Proveedorprincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("PROVEEDOR", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
    ;
  }
}
