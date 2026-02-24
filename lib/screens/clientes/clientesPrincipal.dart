import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/components/buttonColor.dart';

class ClientesPrincipal extends StatefulWidget {
  const ClientesPrincipal({super.key});

  @override
  State<ClientesPrincipal> createState() => _ClientesPrincipalState();
}

class _ClientesPrincipalState extends State<ClientesPrincipal> {
  late Future<List<Cliente>> _futureClientes;
  String _filtroBusqueda = '';

  @override
  void initState() {
    super.initState();
    _futureClientes = ClienteService().obtenerClientes();
  }

  void _recargarLista() {
    setState(() {
      _futureClientes = ClienteService().obtenerClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("CLIENTES", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Izquierda: controles de búsqueda
          Expanded(flex: 4, child: _columnaIzquierda()),
          // Derecha: lista de clientes
          Expanded(flex: 6, child: _columnaDerecha()),
        ],
      ),
    );
  }

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
            name: "Buscar Cliente",
            color: AppColors.secondary,
            alto: 52,
            ancho: 350,
            onFieldSubmitted: (valor) {
              setState(() {
                _filtroBusqueda = valor.trim();
              });
            },
          ),
          const SizedBox(height: 30),
          Buttoncolor(
            name: 'Refrescar',
            alto: 80,
            ancho: 350,
            color: AppColors.secondary,
            function: _recargarLista,
          ),
        ],
      ),
    );
  }

  Widget _columnaDerecha() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      child: FutureBuilder<List<Cliente>>(
        future: _futureClientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(
              child: Text(
                'Error al cargar clientes:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(
              child: Text(
                'No hay clientes registrados.',
                style: TextStyle(fontSize: 20),
              ),
            );

          List<Cliente> clientes = snapshot.data!;

          // Aplicar filtro de búsqueda por nombre o identificacion
          if (_filtroBusqueda.isNotEmpty) {
            final f = _filtroBusqueda.toLowerCase();
            clientes = clientes.where((c) {
              final nombre = '${c.nombre} ${c.apellido}'.toLowerCase();
              final id = c.identificacion.toLowerCase();
              return nombre.contains(f) || id.contains(f);
            }).toList();
          }

          // Ordenar por montoHistorico descendente (mayor a menor gasto)
          clientes.sort((a, b) => b.montoHistorico.compareTo(a.montoHistorico));

          if (clientes.isEmpty)
            return const Center(
              child: Text(
                'No se encontraron clientes con ese filtro.',
                style: TextStyle(fontSize: 18),
              ),
            );

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) =>
                _tarjetaCliente(clientes[index], index + 1),
          );
        },
      ),
    );
  }

  Widget _tarjetaCliente(Cliente c, int posicion) {
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
        border: Border(left: BorderSide(color: AppColors.secondary, width: 5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.secondary,
            child: Text(
              '$posicion',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${c.nombre} ${c.apellido}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ID: ${c.identificacion}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$ ${c.montoHistorico.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 6),
              Text('Historico', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
