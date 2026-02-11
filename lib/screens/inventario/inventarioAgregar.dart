import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class InventarioAgregar extends StatefulWidget {
  const InventarioAgregar({super.key});

  @override
  State<InventarioAgregar> createState() => _InventarioAgregarState();
}

class _InventarioAgregarState extends State<InventarioAgregar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("INVENTARIO", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(children: []),
    );
  }
}
