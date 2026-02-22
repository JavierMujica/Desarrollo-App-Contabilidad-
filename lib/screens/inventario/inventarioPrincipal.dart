import 'dart:convert';
import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/screens/inventario/crearCategoria.dart';
import 'package:desarrollo_de_software/screens/inventario/editarProduccto.dart';
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

  // Variables para almacenar la petición de la API
  late Future<List<Producto>> _futureProductos;
  late Future<List<String>> _futureCategorias;

  // --- VARIABLES DE FILTRADO ---
  String? _categoriaSeleccionada = "Todas";
  String _filtroBusqueda = ""; // <--- NUEVO: Para la búsqueda por texto

  @override
  void initState() {
    super.initState();
    // Llamamos a la API apenas se abre la pantalla
    _futureProductos = ProductoService().obtenerProductos();
    _futureCategorias = CategoriaService().obtenerCategorias();
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
      body: Row(
        children: [
          Expanded(flex: 4, child: _columnaIzquierda()),
          Expanded(flex: 6, child: _columnaDerecha()),
        ],
      ),
    );
  }

  // --- TU COLUMNA IZQUIERDA ACTUALIZADA ---
  Widget _columnaIzquierda() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        bottom: 50.0,
        left: 40,
        right: 20,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: _futureCategorias,
              builder: (context, snapshot) {
                List<String> opcionesCat = ["Todas"];

                if (snapshot.hasData) {
                  opcionesCat.addAll(snapshot.data!);
                }

                return Dropdownformfield(
                  ancho: ancho,
                  alto: alto,
                  color: AppColors.secondary,
                  option: opcionesCat,
                  name: "Filtrar por Categoria",
                  value: _categoriaSeleccionada,
                  onChanged: (valor) {
                    setState(() {
                      _categoriaSeleccionada = valor;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                // --- CAMPO DE BÚSQUEDA ACTUALIZADO ---
                Textfieldfacturacion(
                  name: "Consultar Producto",
                  alto: alto,
                  ancho: 310,
                  color: AppColors.secondary,
                  // ESTO HACE LA MAGIA DE BUSCAR AL DAR ENTER
                  onFieldSubmitted: (valor) {
                    setState(() {
                      _filtroBusqueda = valor.trim();
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ButtonlineIcon(
                        name: "Categoria",
                        alto: 80,
                        ancho: 350,
                        color: AppColors.secondary,
                        page: const Crearcategoria(),
                        icono: Icons.add,
                      ),
                      const SizedBox(height: 20),
                      ButtonlineIcon(
                        name: "Registrar Producto",
                        alto: 80,
                        ancho: 350,
                        color: AppColors.secondary,
                        page: const Editarproduccto(),
                        icono: Icons.add,
                      ),
                      const SizedBox(height: 20),
                      ButtonlineIcon(
                        name: "Eliminar Producto",
                        alto: 80,
                        ancho: 350,
                        color: AppColors.secondary,
                        page: const InventarioAgregar(), // Cambiar luego
                        icono: Icons.remove,
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

  // --- COLUMNA DERECHA BLINDADA (La Lista con Filtros) ---
  Widget _columnaDerecha() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      child: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar inventario:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay productos registrados en la Base de Datos.",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          // 1. Clonamos la lista para no dañar los datos originales en memoria
          List<Producto> productos = List<Producto>.from(snapshot.data!);

          // Chismoso para la consola: Así sabrás cuántos trae la API realmente
          print("Productos reales en la BD: ${productos.length}");

          // 2. FILTRAMOS POR CATEGORÍA (Ignorando mayúsculas y espacios)
          if (_categoriaSeleccionada != null &&
              _categoriaSeleccionada != "Todas") {
            String filtroCat = _categoriaSeleccionada!.trim().toLowerCase();

            productos = productos.where((p) {
              String catProd = (p.categoria ?? "").trim().toLowerCase();
              return catProd == filtroCat;
            }).toList();
          }

          // 3. FILTRAMOS POR BÚSQUEDA DE TEXTO (Ignorando mayúsculas y espacios)
          if (_filtroBusqueda.isNotEmpty) {
            String palabraClave = _filtroBusqueda.trim().toLowerCase();

            productos = productos.where((p) {
              String nombre = (p.nombre ?? "").trim().toLowerCase();
              return nombre.contains(palabraClave);
            }).toList();
          }

          // 4. Si después de filtrar no queda nada
          if (productos.isEmpty) {
            return const Center(
              child: Text(
                "No se encontraron productos con ese filtro o nombre.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // 5. Dibujamos la lista ya filtrada
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final prod = productos[index];
              return _tarjetaProducto(prod);
            },
          );
        },
      ),
    );
  }

  // --- EL DISEÑO DE CADA ITEM ---
  Widget _tarjetaProducto(Producto prod) {
    double precioFinal = prod.costo * prod.ganancia;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 80, height: 80, child: _construirImagen(prod.imagen)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prod.nombre ?? "Sin nombre",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Unidades: ${prod.unidades}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "\$ ${precioFinal.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.positive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirImagen(String? base64String) {
    try {
      if (base64String == null ||
          base64String.isEmpty ||
          base64String == "sin_imagen") {
        return const Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        );
      }
      return Image.memory(base64Decode(base64String), fit: BoxFit.contain);
    } catch (e) {
      return const Icon(
        Icons.broken_image,
        size: 40,
        color: AppColors.negative,
      );
    }
  }
}
