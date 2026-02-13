import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Proveedorregistrar extends StatefulWidget {
  const Proveedorregistrar({super.key});

  @override
  State<Proveedorregistrar> createState() => _ProveedorregistrarState();
}

class _ProveedorregistrarState extends State<Proveedorregistrar> {
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
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            Column(
              children: [
                Textfieldfacturacion(
                  name: "Nombre y Apellido",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Numero de Contacto",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Correo Electronico",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
                SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Empresa",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
              ],
            ),
            SizedBox(width: 80),
            Column(
              children: [
                Textfieldfacturacion(
                  name: "RIF",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                ),
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
          ],
        ),
      ),
    );
  }
}
