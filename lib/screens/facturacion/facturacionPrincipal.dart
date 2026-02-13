// ignore: file_names
import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/facturacion/buscarProducto.dart';
import 'package:flutter/material.dart';

class Facturacionprincipal extends StatefulWidget {
  const Facturacionprincipal({super.key});

  @override
  State<Facturacionprincipal> createState() => _FacturacionprincipalState();
}

class _FacturacionprincipalState extends State<Facturacionprincipal> {
  double _ancho = 400.0;
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
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            //color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Textfieldfacturacion(
                  name: "Cedula",
                  color: AppColors.buttonSecondary,
                  ancho: _ancho,
                  alto: _alto,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Textfieldfacturacion(
                    name: "Nombre Cliente",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Textfieldfacturacion(
                    name: "Direccion",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Textfieldfacturacion(
                    name: "Telefono",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Dropdownformfield(
                    name: "Ciudadano",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    option: ["Venezolano", "Extranjero", "Juridico"],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: [
                      Textfieldfacturacion(
                        name: "Producto",
                        color: AppColors.buttonSecondary,
                        ancho: 180,
                        alto: 60,
                      ),
                      Buttonserch(page: Placeholder()),
                      SizedBox(width: 20),
                      Textfieldfacturacion(
                        name: "Unds.",
                        color: AppColors.buttonSecondary,
                        ancho: 150,
                        alto: 60,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Buttoncolor(
                  name: "Agregar Producto",
                  alto: 68,
                  ancho: 350,
                  page: Placeholder(),
                  color: AppColors.buttonSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
