import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart'; // Importante para la API
import 'package:desarrollo_de_software/core/estructura_db.dart'; // Modelo de datos
import 'package:desarrollo_de_software/screens/proveedores/proveedorRegistrar.dart';
import 'package:flutter/material.dart';

class Proveedorprincipal extends StatefulWidget {
  const Proveedorprincipal({super.key});

  @override
  State<Proveedorprincipal> createState() => _ProveedorprincipalState();
}

class _ProveedorprincipalState extends State<Proveedorprincipal> {
  // Variables para la API y la búsqueda
  late Future<List<Proveedor>> _futureProveedores;
  String _filtroBusqueda = "";

  @override
  void initState() {
    super.initState();
    // Aquí cumples tu promesa y le asignas el valor ANTES de que se dibuje la pantalla
    _futureProveedores = ProveedorService().obtenerProveedores();
  }

  void _recargarLista() {
    setState(() {
      // Al asignarle de nuevo la petición, el FutureBuilder se vuelve a activar
      _futureProveedores = ProveedorService().obtenerProveedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("PROVEEDORES", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // COLUMNA IZQUIERDA (Menú de filtros y botones)
          Expanded(flex: 4, child: _columnaIzquierda()),

          // COLUMNA DERECHA (Lista de proveedores)
          Expanded(flex: 6, child: _columnaDerecha()),
        ],
      ),
    );
  }

  // --- COLUMNA IZQUIERDA: CONTROLES ---
  Widget _columnaIzquierda() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        bottom: 50.0,
        left: 40,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Textfieldfacturacion(
            name: "Buscar Proveedor",
            color: AppColors.secondary,
            alto: 52,
            ancho: 350,
            // Guardamos el texto y redibujamos al dar Enter
            onFieldSubmitted: (valor) {
              setState(() {
                _filtroBusqueda = valor.trim();
              });
            },
          ),
          const SizedBox(height: 45),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ButtonlineIcon(
                    name: "Registrar Proveedor",
                    alto: 80,
                    ancho: 350,
                    color: AppColors.secondary,
                    page:
                        const Proveedorregistrar(), // Va a tu pantalla de crear/editar
                    icono: Icons.add,
                  ),
                  const SizedBox(height: 20),
                  ButtonlineIcon(
                    name: "Eliminar Proveedor",
                    alto: 80,
                    ancho: 350,
                    color: AppColors.secondary,
                    page: const Placeholder(), // Lo conectaremos después
                    icono: Icons.remove,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COLUMNA DERECHA: LISTA DINÁMICA ---
  Widget _columnaDerecha() {
    return Container(
      color: const Color(
        0xFFF8F9FA,
      ), // Un fondo casi blanco para separar el área
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      child: FutureBuilder<List<Proveedor>>(
        future: _futureProveedores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar proveedores:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay proveedores registrados.",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          List<Proveedor> proveedores = snapshot.data!;

          // --- FILTRO DE BÚSQUEDA ---
          if (_filtroBusqueda.isNotEmpty) {
            String filtro = _filtroBusqueda.toLowerCase();
            proveedores = proveedores.where((p) {
              String nombreCompleto = "${p.nombre} ${p.apellido}".toLowerCase();
              String empresa = p.empresa.toLowerCase();

              // Filtramos si el nombre o la empresa contienen lo que se escribió
              return nombreCompleto.contains(filtro) ||
                  empresa.contains(filtro);
            }).toList();
          }

          if (proveedores.isEmpty) {
            return const Center(
              child: Text(
                "No se encontraron proveedores con ese nombre.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Dibujamos las tarjetas
          return ListView.builder(
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              return _tarjetaProveedor(proveedores[index]);
            },
          );
        },
      ),
    );
  }

  // --- DISEÑO DE CADA TARJETA DE PROVEEDOR ---
  Widget _tarjetaProveedor(Proveedor prov) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
        border: Border(
          left: BorderSide(
            color: AppColors.secondary,
            width: 5,
          ), // Línea decorativa
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.business_center, size: 50, color: AppColors.secondary),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prov.empresa.isNotEmpty ? prov.empresa : "Sin empresa",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Contacto: ${prov.nombre} ${prov.apellido}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "RIF/Cédula: ${prov.cedula}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    prov.numeroContacto,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    prov.correoContacto,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
