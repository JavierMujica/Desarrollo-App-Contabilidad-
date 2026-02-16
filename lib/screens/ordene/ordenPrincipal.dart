import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/ordene/ordenRegistrar.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 40,
          right: 40,
          bottom: 60,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Textfieldfacturacion(
                      name: "Nombre Producto",
                      color: AppColors.secondary,
                      alto: 52,
                      ancho: 315,
                    ),
                    Buttonserch(page: Placeholder()),
                  ],
                ),
                SizedBox(height: 45),
                Buttoncolor(
                  alto: 60,
                  ancho: 315,
                  name: "Consultar Orden",
                  page: Placeholder(),
                  color: AppColors.buttonSecondary,
                ),
                Spacer(),
                ButtonlineIcon(
                  name: "Registrar Orden",
                  alto: 80,
                  ancho: 315,
                  color: AppColors.secondary,
                  page: Ordenregistrar(),
                  icono: Icons.add,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
