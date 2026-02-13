import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/proveedores/proveedorRegistrar.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Textfieldfacturacion(
                      name: "Nombre de Proveedor",
                      color: AppColors.secondary,
                      alto: 52,
                      ancho: 350,
                    ),
                    Buttonserch(page: Placeholder()),
                  ],
                ),
                SizedBox(height: 45),
                Buttoncolor(
                  alto: 60,
                  ancho: 350,
                  name: "Consultar Proveedor",
                  page: Placeholder(),
                  color: AppColors.buttonSecondary,
                ),
                Spacer(),
                ButtonlineIcon(
                  name: "Registrar Proveedor",
                  alto: 80,
                  ancho: 350,
                  color: AppColors.secondary,
                  page: Proveedorregistrar(),
                  icono: Icons.add,
                ),
                SizedBox(height: 20),
                ButtonlineIcon(
                  name: "Eliminar Proveedor",
                  alto: 80,
                  ancho: 350,
                  color: AppColors.secondary,
                  page: Placeholder(),
                  icono: Icons.remove,
                ),
                SizedBox(height: 20),
                ButtonlineIcon(
                  name: "Editar Proveedor",
                  alto: 80,
                  ancho: 350,
                  color: AppColors.secondary,
                  page: Placeholder(),
                  icono: Icons.edit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
