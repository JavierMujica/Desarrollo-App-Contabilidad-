import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/fechaField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Ordenregistrar extends StatefulWidget {
  const Ordenregistrar({super.key});

  @override
  State<Ordenregistrar> createState() => _OrdenregistrarState();
}

class _OrdenregistrarState extends State<Ordenregistrar> {
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
      body: Padding(
        padding: EdgeInsets.only(top: 40.0, left: 40, right: 40, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Textfieldfacturacion(
                  name: "Producto",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Buttonserch(page: Placeholder()),
              ],
            ),
            SizedBox(height: 66),
            Textfieldfacturacion(
              name: "Unidades",
              color: AppColors.secondary,
              alto: 52,
              ancho: 315,
            ),
            SizedBox(height: 66),
            Textfieldfacturacion(
              name: "Costo-Unidad",
              color: AppColors.secondary,
              alto: 52,
              ancho: 315,
            ),
            SizedBox(height: 66),
            Fechafield(name: "Fecha-Tentativa", color: AppColors.secondary),
            Spacer(),
            Buttoncolor(
              alto: 58,
              ancho: 315,
              name: "Registrar",
              page: Placeholder(),
              color: AppColors.buttonSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
