import 'package:desarrollo_de_software/components/buttonLine.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/reportes/reportesCostos.dart';
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Buttonline(
              name: "Costos",
              alto: 110,
              ancho: 205,
              color: AppColors.secondary,
              page: Reportescostos(),
            ),
            SizedBox(width: 56),
            Buttonline(
              name: "Facturacion",
              alto: 110,
              ancho: 205,
              color: AppColors.secondary,
              page: Placeholder(),
            ),
            SizedBox(width: 56),
            Buttonline(
              name: "Ganancias",
              alto: 110,
              ancho: 205,
              color: AppColors.secondary,
              page: Placeholder(),
            ),
            SizedBox(width: 56),
            Buttonline(
              name: "Ventas",
              alto: 110,
              ancho: 205,
              color: AppColors.secondary,
              page: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
