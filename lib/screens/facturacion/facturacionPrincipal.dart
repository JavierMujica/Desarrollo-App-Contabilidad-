// ignore: file_names
import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/clock.dart';
import 'package:flutter/material.dart';

class Facturacionprincipal extends StatefulWidget {
  const Facturacionprincipal({super.key});

  @override
  State<Facturacionprincipal> createState() => _FacturacionprincipalState();
}

class _FacturacionprincipalState extends State<Facturacionprincipal> {
  final double _ancho = 400.0;
  final double _alto = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("FACTURACION", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Give the form a flexible width
            Informacion(),
            const SizedBox(width: 40),
            // Give the clock a flexible width
            const Expanded(flex: 0, child: MinimalClockWidget()),
          ],
        ),
      ),
    );
  }

  Widget Informacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wrap ONLY the scrolling fields in an Expanded + ScrollView
        Expanded(
          child: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Textfieldfacturacion(
                    name: "Cedula",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                  const SizedBox(height: 15),
                  Textfieldfacturacion(
                    name: "Nombre Cliente",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                  const SizedBox(height: 15),
                  Textfieldfacturacion(
                    name: "Direccion",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                  const SizedBox(height: 15),
                  Textfieldfacturacion(
                    name: "Telefono",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                  const SizedBox(height: 15),
                  Dropdownformfield(
                    name: "Ciudadano",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    option: const ["Venezolano", "Extranjero", "Juridico"],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Textfieldfacturacion(
                        name: "Producto",
                        color: AppColors.buttonSecondary,
                        ancho: 180,
                        alto: 60,
                      ),
                      Buttonserch(page: Placeholder()),
                      const SizedBox(width: 20),
                      Textfieldfacturacion(
                        name: "Unds.",
                        color: AppColors.buttonSecondary,
                        ancho: 150,
                        alto: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // This part stays at the bottom
        const SizedBox(height: 20),
        Buttoncolor(
          name: "Agregar Producto",
          alto: 68,
          ancho: 350,
          page: Placeholder(),
          color: AppColors.buttonSecondary,
        ),
      ],
    );
  }
}
