import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/facturacion/buscarProducto.dart';
import 'package:desarrollo_de_software/screens/inventario/inventarioAgregar.dart';
import 'package:flutter/material.dart';

class Inventarioprincipal extends StatefulWidget {
  const Inventarioprincipal({super.key});

  @override
  State<Inventarioprincipal> createState() => _InventarioprincipalState();
}

class _InventarioprincipalState extends State<Inventarioprincipal> {
  double ancho = 370;
  double alto = 70;
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
      body: Row(children: [Expanded(child: ColumnaIzquierda())]),
    );
  }

  // ignore: non_constant_identifier_names
  Padding ColumnaIzquierda() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Dropdownformfield(
            ancho: ancho,
            alto: alto,
            color: AppColors.secondary,
            option: [],
            name: "Filtrar por Categoria",
          ),
          Row(
            children: [
              Textfieldfacturacion(
                name: "Consultar Producto",
                alto: alto,
                ancho: 310,
                color: AppColors.secondary,
              ),
              Buttonserch(page: Placeholder()),
            ],
          ),
          Spacer(),
          ButtonlineIcon(
            name: "Agregar",
            alto: 80,
            ancho: 200,
            color: AppColors.secondary,
            page: InventarioAgregar(),
            icono: Icons.add,
          ),
          SizedBox(height: 20),
          ButtonlineIcon(
            name: "Eliminar",
            alto: 80,
            ancho: 200,
            color: AppColors.secondary,
            page: InventarioAgregar(),
            icono: Icons.remove,
          ),
          SizedBox(height: 20),
          ButtonlineIcon(
            name: "Editar",
            alto: 80,
            ancho: 200,
            color: AppColors.secondary,
            page: InventarioAgregar(),
            icono: Icons.edit,
          ),
          SizedBox(height: 0),
        ],
      ),
    );
  }
}
