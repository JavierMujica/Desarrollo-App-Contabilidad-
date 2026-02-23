import 'dart:convert';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:flutter/material.dart';

class EliminarInventario extends StatefulWidget {
  const EliminarInventario({super.key});

  @override
  State<EliminarInventario> createState() => _EliminarInventarioState();
}

class _EliminarInventarioState extends State<EliminarInventario> {
  late Future<List<Producto>> _futureProductos;
  String _filtro = "";

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    _futureProductos = ProductoService().obtenerProductos();
  }

  Future<void> _confirmarYEliminar(Producto prod) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar el producto "${prod.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    // Llamamos al servicio para eliminar
    bool ok = await ProductoService().eliminarProducto(prod.codigo);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto "${prod.nombre}" eliminado.')),
      );
      setState(() {
        _cargarProductos();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el producto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text('ELIMINAR PRODUCTO', style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Textfieldfacturacion(
                name: 'Buscar por nombre',
                color: AppColors.secondary,
                alto: 52,
                ancho: 500,
                onFieldSubmitted: (valor) {
                  setState(() {
                    _filtro = valor.trim();
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 20,
              ),
              child: FutureBuilder<List<Producto>>(
                future: _futureProductos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error al cargar productos',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  List<Producto> productos = snapshot.data ?? [];

                  if (_filtro.isNotEmpty) {
                    productos = productos.where((p) {
                      String nombre = (p.nombre ?? '').toLowerCase();
                      return nombre.contains(_filtro.toLowerCase());
                    }).toList();
                  }

                  productos.sort(
                    (a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''),
                  );

                  if (productos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No se encontraron productos.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      return _tarjetaConEliminar(productos[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaConEliminar(Producto prod) {
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
        children: [
          SizedBox(width: 80, height: 80, child: _construirImagen(prod.imagen)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prod.nombre ?? 'Sin nombre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unidades: ${prod.unidades}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Código: ${prod.codigo}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$ ${precioFinal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.positive,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _confirmarYEliminar(prod),
                    icon: const Icon(Icons.delete_forever),
                    color: Colors.red,
                    tooltip: 'Eliminar producto',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _construirImagen(String? base64String) {
    try {
      if (base64String == null ||
          base64String.isEmpty ||
          base64String == 'sin_imagen') {
        return const Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        );
      }
      return Image.memory(base64Decode(base64String), fit: BoxFit.contain);
    } catch (e) {
      return const Icon(Icons.broken_image, size: 40, color: Colors.red);
    }
  }
}
