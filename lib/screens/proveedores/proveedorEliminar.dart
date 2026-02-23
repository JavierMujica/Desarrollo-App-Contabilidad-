import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:flutter/material.dart';

class ProveedorEliminar extends StatefulWidget {
  const ProveedorEliminar({super.key});

  @override
  State<ProveedorEliminar> createState() => _ProveedorEliminarState();
}

class _ProveedorEliminarState extends State<ProveedorEliminar> {
  late Future<List<Proveedor>> _futureProveedores;
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  void _cargarProveedores() {
    _futureProveedores = ProveedorService().obtenerProveedores();
  }

  Future<void> _confirmarYEliminar(Proveedor prov) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar al proveedor "${prov.nombre} ${prov.apellido}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.negative),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    bool ok = await ProveedorService().eliminarProveedor(prov.cedula);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Proveedor "${prov.nombre}" eliminado.')));
      setState(() {
        _cargarProveedores();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar el proveedor.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text('ELIMINAR PROVEEDOR', style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Textfieldfacturacion(
                name: 'Buscar por nombre o empresa',
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
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: FutureBuilder<List<Proveedor>>(
                future: _futureProveedores,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar proveedores', style: TextStyle(color: Colors.red)));
                  }

                  List<Proveedor> proveedores = snapshot.data ?? [];

                  if (_filtro.isNotEmpty) {
                    proveedores = proveedores.where((p) {
                      final f = _filtro.toLowerCase();
                      return (p.nombre.toLowerCase().contains(f) || p.apellido.toLowerCase().contains(f) || p.empresa.toLowerCase().contains(f) || p.cedula.toLowerCase().contains(f));
                    }).toList();
                  }

                  proveedores.sort((a, b) => (a.nombre).compareTo(b.nombre));

                  if (proveedores.isEmpty) {
                    return const Center(child: Text('No se encontraron proveedores.', style: TextStyle(fontSize: 18)));
                  }

                  return ListView.builder(
                    itemCount: proveedores.length,
                    itemBuilder: (context, index) => _tarjetaProveedor(proveedores[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaProveedor(Proveedor prov) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          const Icon(Icons.person, size: 48, color: Colors.grey),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${prov.nombre} ${prov.apellido}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                const SizedBox(height: 6),
                Text('Empresa: ${prov.empresa}', style: const TextStyle(fontSize: 14)),
                Text('Contacto: ${prov.numeroContacto}    Correo: ${prov.correoContacto}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                Text('Cédula: ${prov.cedula}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmarYEliminar(prov),
            icon: const Icon(Icons.delete_forever),
            color: Colors.red,
            tooltip: 'Eliminar proveedor',
          ),
        ],
      ),
    );
  }
}
