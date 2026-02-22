import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/screens/buscarProduccto.dart';

import 'package:flutter/material.dart';

class Editarproduccto extends StatefulWidget {
  const Editarproduccto({super.key});

  @override
  State<Editarproduccto> createState() => _EditarproducctoState();
}

class _EditarproducctoState extends State<Editarproduccto> {
  // 1. EL RECOLECTOR GENERAL
  Map<String, dynamic> formulario = {};

  // VARIABLES PARA LA UI
  int _resetKey = 0;
  bool _mostrarExito = false;
  bool _esEdicion = false;

  // VARIABLES PARA LOS DROPDOWNS
  late Future<List<String>> _futureCategorias;
  late Future<List<String>> _futureProveedores;

  @override
  void initState() {
    super.initState();
    _futureCategorias = CategoriaService().obtenerCategorias();
    _futureProveedores = ProveedorService().obtenerProveedores().then(
      (proveedores) => proveedores.map((p) => p.empresa).toList(),
    );
  }

  // Función para ir a la pantalla de búsqueda y recibir el código
  void _abrirBusquedaPorNombre() async {
    // Viajamos a la pantalla y ESPERAMOS (await) a que el usuario toque una tarjeta
    final codigoSeleccionado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BuscarProducto(),
      ), // Asegúrate de importar el archivo
    );

    // Si el usuario tocó una tarjeta (no se devolvió con la flecha atrás)
    if (codigoSeleccionado != null) {
      setState(() {
        formulario["Codigo"] = codigoSeleccionado; // Rellenamos el mapa
        _resetKey++; // Redibujamos para que el código aparezca en el TextField
      });

      // Llamamos al autocompletado para llenar el resto de los datos
      _buscarPorCodigo();
    }
  }

  // --- FUNCIÓN: BUSCAR Y AUTOCOMPLETAR ---
  void _buscarPorCodigo() async {
    String codigo = formulario["Codigo"] ?? "";
    if (codigo.isEmpty) return;

    try {
      final api = ProductoService();
      List<Producto> resultados = await api.obtenerProductos(codigo: codigo);

      if (resultados.isNotEmpty) {
        Producto p = resultados.first;

        setState(() {
          _esEdicion = true; // Entramos en modo edición

          formulario["Nombre"] = p.nombre;
          formulario["Unidades"] = p.unidades.toString();
          formulario["Costo-Unidad"] = p.costo.toString();
          formulario["Ganacia"] = p.ganancia.toString();
          formulario["Limite"] = p.limiteExistencia.toString();
          formulario["Categoria"] = p.categoria;
          formulario["Proveedor"] = p.proveedor;

          _resetKey++;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Producto encontrado. Modo edición activado."),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        setState(() {
          _esEdicion = false;
        });
      }
    } catch (e) {
      print("Error buscando: $e");
    }
  }

  // --- FUNCIÓN DE GUARDAR ARREGLADA ---
  void _enviarDatos() async {
    try {
      final productoPreparado = Producto(
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
      bool exito;

      if (_esEdicion) {
        exito = await api.actualizarProducto(productoPreparado);
      } else {
        exito = await api.crearProducto(productoPreparado);
      }

      if (exito) {
        // 1. Limpiamos los campos y mostramos el éxito, pero MANTENEMOS _esEdicion
        // para que el texto diga "¡Actualizado!"
        setState(() {
          formulario.clear();
          _resetKey++;
          _mostrarExito = true;
        });

        // 2. Esperamos 2 segundos
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // 3. Ocultamos el mensaje y ahora sí apagamos el modo edición
            setState(() {
              _mostrarExito = false;
              _esEdicion = false;
            });
          }
        });
      } else {
        // ¡NUEVO! Si falla en el backend, te avisa por qué "no funciona el botón"
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Error al guardar en la base de datos. Revisa los campos.",
            ),
            backgroundColor: Colors.red,
          ),
        );
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
        title: Text(
          _esEdicion ? "EDITAR PRODUCTO" : "NUEVO PRODUCTO",
          style: TextStyles.bodyButton,
        ),
        centerTitle: true,
      ),
      body: Row(
        key: ValueKey(_resetKey),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Textfieldfacturacion(
                      name: "Codigo",
                      color: AppColors.secondary,
                      alto: 52,
                      ancho: 250, // Lo acortamos para que quepa el botón
                      initialValue: formulario["Codigo"],
                      onChanged: (valor) => formulario["Codigo"] = valor,
                      onFieldSubmitted: (valor) =>
                          _buscarPorCodigo(), // Enter busca directo por código
                    ),
                    const SizedBox(width: 10),
                    // Botón para buscar por nombre
                    Container(
                      height: 52,
                      width: 55,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        tooltip: "Buscar por Nombre",
                        onPressed:
                            _abrirBusquedaPorNombre, // <--- LLAMA A LA NUEVA PANTALLA
                      ),
                    ),
                  ],
                ),
                Textfieldfacturacion(
                  name: "Nombre",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Nombre"],
                  onChanged: (valor) => formulario["Nombre"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Unidades",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Unidades"],
                  onChanged: (valor) => formulario["Unidades"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Costo-Unidad",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Costo-Unidad"],
                  onChanged: (valor) => formulario["Costo-Unidad"] = valor,
                ),
                Textfieldfacturacion(
                  name: "Ganacia (%)",
                  color: AppColors.secondary,
                  alto: 52,
                  ancho: 315,
                  initialValue: formulario["Ganacia"],
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
                  initialValue: formulario["Limite"],
                  onChanged: (valor) => formulario["Limite"] = valor,
                ),

                // --- FUTURE BUILDER CATEGORÍA (CON FILTRO DE SEGURIDAD) ---
                FutureBuilder<List<String>>(
                  future: _futureCategorias,
                  builder: (context, snapshot) {
                    List<String> opcionesCat = snapshot.data ?? [];
                    String? valorSeguroCat = formulario["Categoria"];

                    if (valorSeguroCat != null &&
                        !opcionesCat.contains(valorSeguroCat)) {
                      try {
                        valorSeguroCat = opcionesCat.firstWhere(
                          (cat) =>
                              cat.toLowerCase() ==
                              valorSeguroCat!.toLowerCase(),
                        );
                        formulario["Categoria"] = valorSeguroCat;
                      } catch (e) {
                        valorSeguroCat = null;
                      }
                    }

                    return Dropdownformfield(
                      alto: 52,
                      ancho: 315,
                      option: opcionesCat,
                      name: "Categoria",
                      color: AppColors.secondary,
                      value: valorSeguroCat,
                      onChanged: (valor) {
                        setState(() {
                          formulario["Categoria"] = valor;
                        });
                      },
                    );
                  },
                ),

                // --- FUTURE BUILDER PROVEEDOR (CON FILTRO DE SEGURIDAD) ---
                FutureBuilder<List<String>>(
                  future: _futureProveedores,
                  builder: (context, snapshot) {
                    List<String> opcionesProv = snapshot.data ?? [];
                    String? valorSeguroProv = formulario["Proveedor"];

                    if (valorSeguroProv != null &&
                        !opcionesProv.contains(valorSeguroProv)) {
                      try {
                        valorSeguroProv = opcionesProv.firstWhere(
                          (prov) =>
                              prov.toLowerCase() ==
                              valorSeguroProv!.toLowerCase(),
                        );
                        formulario["Proveedor"] = valorSeguroProv;
                      } catch (e) {
                        valorSeguroProv = null;
                      }
                    }

                    return Dropdownformfield(
                      alto: 52,
                      ancho: 315,
                      option: opcionesProv,
                      name: "Proveedor",
                      color: AppColors.secondary,
                      value: valorSeguroProv,
                      onChanged: (valor) {
                        setState(() {
                          formulario["Proveedor"] = valor;
                        });
                      },
                    );
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
                  name: _esEdicion ? "Actualizar" : "Crear",
                  color: AppColors.buttonSecondary,
                  function: _enviarDatos,
                ),
              ],
            ),
          ),

          // --- MENSAJE DE ÉXITO ANIMADO ---
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
                      _esEdicion ? "¡Actualizado!" : "¡Creado!",
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
    );
  }
}
