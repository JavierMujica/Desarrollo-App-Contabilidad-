import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
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
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Textfieldfacturacion(
                  name: "Codigo",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Textfieldfacturacion(
                  name: "Nombre",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Textfieldfacturacion(
                  name: "Unidades",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Textfieldfacturacion(
                  name: "Costo-Unidad",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Textfieldfacturacion(
                  name: "Ganacia (%)",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
              ],
            ),
          ),
          Padding(
            //color: AppColors.negative,
            padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Textfieldfacturacion(
                  name: "Limite de Existencia",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                Dropdownformfield(
                  alto: 52,
                  ancho: 315,
                  option: [],
                  name: "Categoria",
                  color: AppColors.secondary,
                ),
                Dropdownformfield(
                  alto: 52,
                  ancho: 315,
                  option: [],
                  name: "Proveedor",
                  color: AppColors.secondary,
                ),
                Buttoncolor(
                  alto: 60,
                  ancho: 315,
                  name: "Imagen",
                  page: Placeholder(),
                  color: AppColors.secondary,
                ),
                Buttoncolor(
                  alto: 60,
                  ancho: 315,
                  name: "Imagen",
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
