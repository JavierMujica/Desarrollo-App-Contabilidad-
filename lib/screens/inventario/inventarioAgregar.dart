import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:flutter/material.dart';

class InventarioAgregar extends StatefulWidget {
  const InventarioAgregar({super.key});

  @override
  State<InventarioAgregar> createState() => _InventarioAgregarState();
}

class _InventarioAgregarState extends State<InventarioAgregar> {
  // 1. EL RECOLECTOR GENERAL
  Map<String, dynamic> formulario = {};

  // NUEVAS VARIABLES PARA LA UI
  int _resetKey = 0; // Se usará para forzar la limpieza visual de los campos
  bool _mostrarExito = false; // Controla si se ve el mensaje "Creado"

  // 2. LA FUNCIÓN GENERAL DE GUARDADO
  void _enviarDatos() async {
    print("Datos listos para enviar: $formulario");

    try {
      final nuevoProducto = Producto(
        codigo: formulario["Codigo"] ?? "",
        nombre: formulario["Nombre"] ?? "",
        unidades: int.tryParse(formulario["Unidades"] ?? "0") ?? 0,
        costo: double.tryParse(formulario["Costo-Unidad"] ?? "0") ?? 0.0,
        ganancia: double.tryParse(formulario["Ganacia"] ?? "0") ?? 0.0,
        limiteExistencia: int.tryParse(formulario["Limite"] ?? "0") ?? 0,
        categoria: formulario["Categoria"] ?? "General",
        proveedor: formulario["Proveedor"] ?? "Desconocido",
        imagen:
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=",
      );

      final api = ProductoService();
      bool exito = await api.crearProducto(nuevoProducto);

      if (exito) {
        setState(() {
          formulario.clear();
          _resetKey++;
          _mostrarExito = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _mostrarExito = false;
            });
          }
        });
      }
    } catch (e) {
      print("Error al armar los datos: $e");
    }
  }

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
      // Le agregamos la llave a todo el Row. Cuando _resetKey cambia, esto se redibuja de cero.
      body: Row(
        key: ValueKey(_resetKey),
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
                  onChanged: (valor) => formulario["Codigo"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Nombre",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  onChanged: (valor) => formulario["Nombre"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Unidades",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  onChanged: (valor) => formulario["Unidades"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Costo-Unidad",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  onChanged: (valor) => formulario["Costo-Unidad"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Ganacia (%)",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  onChanged: (valor) => formulario["Ganacia"] = valor,
                ),
              ],
            ),
          ),
          Padding(
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
                  onChanged: (valor) => formulario["Limite"] = valor,
                ),
                Dropdownformfield(
                  alto: 52,
                  ancho: 315,
                  option: const ["Electrónica", "Ropa", "Alimentos"],
                  name: "Categoria",
                  color: AppColors.secondary,
                  value: formulario["Categoria"],
                  onChanged: (valor) {
                    setState(() {
                      formulario["Categoria"] = valor;
                    });
                  },
                ),
                Dropdownformfield(
                  alto: 52,
                  ancho: 315,
                  option: const ["Proveedor A", "Proveedor B"],
                  name: "Proveedor",
                  color: AppColors.secondary,
                  value: formulario["Proveedor"],
                  onChanged: (valor) {
                    setState(() {
                      formulario["Proveedor"] = valor;
                    });
                  },
                ),
                Buttoncolor(
                  alto: 60,
                  ancho: 315,
                  name: "Imagen",
                  page: const Placeholder(),
                  color: AppColors.secondary,
                ),
                Buttoncolor(
                  alto: 60,
                  ancho: 315,
                  name: "Crear",
                  color: AppColors.buttonSecondary,
                  function: _enviarDatos,
                ),
              ],
            ),
          ),
          // --- NUEVO ESPACIO A LA DERECHA PARA EL MENSAJE ---
          Expanded(
            child: Center(
              // Usamos un AnimatedOpacity para que el mensaje aparezca y desaparezca suavemente
              child: AnimatedOpacity(
                opacity: _mostrarExito ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.buttonSecondary,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "¡Creado!",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color:
                            AppColors.buttonSecondary, // Combina con tu botón
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
