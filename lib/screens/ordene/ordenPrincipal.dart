import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonLineIcon.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/screens/ordene/ordenRegistrar.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart'; // Importante para usar los servicios
import 'package:desarrollo_de_software/core/estructura_db.dart'; // Importante para los modelos
import 'package:flutter/material.dart';

class Ordenprincipal extends StatefulWidget {
  const Ordenprincipal({super.key});

  @override
  State<Ordenprincipal> createState() => _OrdenprincipalState();
}

class _OrdenprincipalState extends State<Ordenprincipal> {
  // Variables para la búsqueda y los datos
  String _filtroBusqueda = "";
  late Future<List<Orden>> _futureOrdenes; // Usaremos el modelo Orden

  @override
  void initState() {
    super.initState();
    _cargarOrdenes();
  }

  void _cargarOrdenes() {
    // Usamos el servicio para traer las órdenes (asegúrate de tener este método en tu conexion_db.dart)
    _futureOrdenes = OrdenService().obtenerOrdenes();
  }

  // --- FUNCIÓN QUE SE EJECUTA AL DARLE "RECIBIDO" ---
  void _marcarComoRecibido(Orden orden) async {
    try {
      // 1. Clonamos la orden y cambiamos su estado a recibida
      final ordenActualizada = Orden(
        id: orden.id, // Suponiendo que tu modelo Orden tiene ID
        producto: orden.producto,
        cantidad: orden.cantidad,
        fechaLlegada: orden.fechaLlegada,
        costo: orden.costo,
        recibida: true, // ¡La marcamos como recibida!
      );

      // 2. Enviamos el PUT a la API
      bool exito = await OrdenService().actualizarOrden(
        ordenActualizada as int,
      );

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Orden recibida!"),
            backgroundColor: AppColors.positive,
          ),
        );
        // 3. Recargamos la lista para que el botón desaparezca y el texto diga "Recibido"
        setState(() {
          _cargarOrdenes();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al procesar la orden."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error al procesar la orden: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("ORDENES", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // COLUMNA IZQUIERDA (40%)
          Expanded(flex: 4, child: _columnaIzquierda()),

          // COLUMNA DERECHA (60%)
          Expanded(flex: 6, child: _columnaDerecha()),
        ],
      ),
    );
  }

  // --- COLUMNA IZQUIERDA (Controles) ---
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
            name: "Nombre producto",
            color: AppColors.secondary,
            alto: 52,
            ancho: 350,
            onFieldSubmitted: (valor) {
              setState(() {
                _filtroBusqueda = valor.trim().toLowerCase();
              });
            },
          ),
          const SizedBox(height: 20),
          Buttoncolor(
            alto: 52,
            ancho: 350,
            name: "Consultar orden",
            color: const Color(0xFF2563EB), // El azul de tu diseño
            function: () {
              setState(() {}); // Fuerza la recarga para aplicar el filtro
            },
          ),

          const Spacer(),

          ButtonlineIcon(
            name: "Registrar orden",
            alto: 80,
            ancho: 350,
            color: AppColors.secondary,
            page: const Ordenregistrar(), // Botón que va al formulario
            icono: Icons.add,
          ),
        ],
      ),
    );
  }

  // --- COLUMNA DERECHA (Lista de Órdenes) ---
  Widget _columnaDerecha() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      child: FutureBuilder<List<Orden>>(
        future: _futureOrdenes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar órdenes:\n${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay órdenes registradas.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          List<Orden> ordenes = snapshot.data!;

          // FILTRO POR NOMBRE DE PRODUCTO (Si el usuario escribió algo)
          if (_filtroBusqueda.isNotEmpty) {
            ordenes = ordenes.where((o) {
              String producto = (o.producto).toLowerCase();
              return producto.contains(_filtroBusqueda);
            }).toList();
          }

          if (ordenes.isEmpty) {
            return const Center(
              child: Text(
                "No se encontraron órdenes para ese producto.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: ordenes.length,
            itemBuilder: (context, index) {
              return _tarjetaOrden(ordenes[index]);
            },
          );
        },
      ),
    );
  }

  // --- DISEÑO DE LA TARJETA ---
  Widget _tarjetaOrden(Orden orden) {
    bool estaPendiente = !orden.recibida;

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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Espacio para la imagen (o ícono si no guardas imagen en Orden)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 30),

          // Textos informativos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orden.producto,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Unidades: ${orden.cantidad}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Fecha llegada: ${orden.fechaLlegada}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Estado: ${estaPendiente ? 'Pendiente' : 'Recibido'}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: estaPendiente ? Colors.orange : AppColors.positive,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Costo/unidad: \$${orden.costo.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Orden: #${orden.id}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Botón "Recibido" (Solo aparece si el estado en BD es recibida = false)
          if (estaPendiente)
            ElevatedButton(
              onPressed: () => _marcarComoRecibido(orden),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // Azul brillante
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Recibido",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
