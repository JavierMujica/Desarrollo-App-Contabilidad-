import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Reportescostos extends StatefulWidget {
  const Reportescostos({super.key});

  @override
  State<Reportescostos> createState() => _ReportescostosState();
}

class _ReportescostosState extends State<Reportescostos> {
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
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            Column(
              children: [
                Dropdownformfield(
                  color: AppColors.secondary,
                  alto: 68,
                  ancho: 356,
                  option: [
                    "Ultimo semana",
                    "Ultimo Mes",
                    "Ultimos Trimestre",
                    "Ultimo Semestre",
                    "Ultimo Año",
                    "Historial",
                  ],
                  name: "Temporalidad",
                ),
                Buttoncolor(
                  alto: 58,
                  ancho: 315,
                  name: "Generar",
                  page: Placeholder(),
                  color: AppColors.buttonSecondary,
                ),
                Spacer(),
                Text("Total: ", style: TextStyles.bodyText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
