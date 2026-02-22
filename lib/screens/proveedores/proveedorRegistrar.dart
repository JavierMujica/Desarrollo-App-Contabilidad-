import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:flutter/material.dart';

class Proveedorregistrar extends StatefulWidget {
  const Proveedorregistrar({super.key});

  @override
  State<Proveedorregistrar> createState() => _ProveedorregistrarState();
}

class _ProveedorregistrarState extends State<Proveedorregistrar> {
  // 1. EL RECOLECTOR GENERAL
  Map<String, dynamic> formulario = {};

  // 2. VARIABLES PARA LA UI
  int _resetKey = 0;
  bool _mostrarExito = false;
  bool _esEdicion = false;

  // --- FUNCIÓN: BUSCAR Y AUTOCOMPLETAR ---
  void _buscarPorRif() async {
    String rif = formulario["RIF"] ?? "";
    if (rif.isEmpty) return;

    try {
      final api = ProveedorService();
      // Buscamos si el proveedor ya existe usando el RIF/Cedula
      List<Proveedor> resultados = await api.obtenerProveedores(cedula: rif);

      if (resultados.isNotEmpty) {
        Proveedor p = resultados.first;

        setState(() {
          _esEdicion = true; // Entramos en modo edición

          // Llenamos el mapa con los datos de la base de datos
          // Unimos nombre y apellido para tu campo visual
          formulario["Nombre y Apellido"] = "${p.nombre} ${p.apellido}".trim();
          formulario["Numero de Contacto"] = p.numeroContacto;
          formulario["Correo Electronico"] = p.correoContacto;
          formulario["Empresa"] = p.empresa;
          formulario["RIF"] = p.cedula;

          _resetKey++; // Redibujamos la UI
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Proveedor encontrado. Modo edición activado."),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        setState(() {
          _esEdicion = false;
        });
      }
    } catch (e) {
      print("Error buscando proveedor: $e");
    }
  }

  // --- FUNCIÓN DE GUARDAR / ACTUALIZAR ---
  void _enviarDatos() async {
    try {
      // Separar "Nombre y Apellido" en dos variables para la API
      String nombreCompleto = formulario["Nombre y Apellido"] ?? "";
      List<String> partes = nombreCompleto.split(" ");
      String nombreApi = partes.isNotEmpty ? partes[0] : "";
      // Si hay más palabras, las juntamos como apellido
      String apellidoApi = partes.length > 1 ? partes.sublist(1).join(" ") : "";

      final proveedorPreparado = Proveedor(
        nombre: nombreApi,
        apellido: apellidoApi,
        cedula: formulario["RIF"] ?? "",
        numeroContacto: formulario["Numero de Contacto"] ?? "",
        correoContacto: formulario["Correo Electronico"] ?? "",
        empresa: formulario["Empresa"] ?? "",
      );

      final api = ProveedorService();
      bool exito;

      if (_esEdicion) {
        exito = await api.actualizarProveedor(proveedorPreparado); // PUT
      } else {
        exito = await api.crearProveedor(proveedorPreparado); // POST
      }

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
              _esEdicion = false;
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al guardar en la base de datos."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error al armar los datos del proveedor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text(
          _esEdicion ? "EDITAR PROVEEDOR" : "NUEVO PROVEEDOR",
          style: TextStyles.bodyButton,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          key: ValueKey(_resetKey),
          children: [
            // --- COLUMNA IZQUIERDA ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textfieldfacturacion(
                  name: "Nombre y Apellido",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Nombre y Apellido"],
                  onChanged: (valor) => formulario["Nombre y Apellido"] = valor,
                ),
                const SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Numero de Contacto",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Numero de Contacto"],
                  onChanged: (valor) =>
                      formulario["Numero de Contacto"] = valor,
                ),
                const SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Correo Electronico",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Correo Electronico"],
                  onChanged: (valor) =>
                      formulario["Correo Electronico"] = valor,
                ),
                const SizedBox(height: 60),
                Textfieldfacturacion(
                  name: "Empresa",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Empresa"],
                  onChanged: (valor) => formulario["Empresa"] = valor,
                ),
              ],
            ),
            const SizedBox(width: 80),

            // --- COLUMNA DERECHA ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CAMPO RIF: AQUÍ ESTÁ EL DISPARADOR CON onFieldSubmitted
                Textfieldfacturacion(
                  name: "RIF",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["RIF"],
                  onChanged: (valor) => formulario["RIF"] = valor,
                  onFieldSubmitted: (valor) =>
                      _buscarPorRif(), // <--- Activa la búsqueda al dar Enter
                ),
                const Spacer(),
                Buttoncolor(
                  alto: 58,
                  ancho: 315,
                  name: _esEdicion ? "Actualizar" : "Registrar",
                  color: AppColors.buttonSecondary,
                  function: _enviarDatos, // <--- Conectado al backend
                ),
              ],
            ),

            // --- ANIMACIÓN DE ÉXITO A LA DERECHA ---
            Expanded(
              child: Center(
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
                        _esEdicion ? "¡Actualizado!" : "¡Registrado!",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
