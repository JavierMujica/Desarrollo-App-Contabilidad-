// ignore: file_names
import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/buttonSerch.dart';
import 'package:desarrollo_de_software/components/dropDownFormField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/screens/buscarProduccto.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/clock.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Facturacionprincipal extends StatefulWidget {
  const Facturacionprincipal({super.key});

  @override
  State<Facturacionprincipal> createState() => _FacturacionprincipalState();
}

class _FacturacionprincipalState extends State<Facturacionprincipal> {
  final double _ancho = 400.0;
  final double _alto = 50.0;
  // Cliente
  String _cedula = '';
  String _nombreCliente = '';
  String _apellidoCliente = '';
  String _nacionalidad = 'Venezolano';

  // Items de la factura
  final List<_FacturaItem> _items = [];
  // Controllers for product code and units
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _undsController = TextEditingController(
    text: '1',
  );

  @override
  void dispose() {
    _codigoController.dispose();
    _undsController.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (s, it) => s + it.total);
  double get _iva => double.parse((_subtotal * 0.16).toStringAsFixed(2));
  double get _total => double.parse((_subtotal + _iva).toStringAsFixed(2));

  Future<void> _buscarYAgregarProducto() async {
    // Navega a buscar producto y espera el codigo retornado
    final codigo = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const BuscarProducto()),
    );
    if (codigo == null) return;

    // Poner el codigo en el campo para que el usuario complete unidades y luego presione Agregar
    setState(() {
      _codigoController.text = codigo;
    });
  }

  Future<void> _agregarProductoDesdeCampos() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Código vacío'),
          content: const Text('Ingrese el código del producto.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final unidades = int.tryParse(_undsController.text.trim()) ?? 0;
    if (unidades <= 0) {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Cantidad inválida'),
          content: const Text('Ingrese una cantidad válida.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final productos = await ProductoService().obtenerProductos(
        codigo: codigo,
      );
      if (productos.isEmpty) {
        await showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('No encontrado'),
            content: const Text('Producto no encontrado para ese código.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final prod = productos.first;

      // Compute how many of this product are already in the cart
      final int alreadyInCart = _items
          .where((it) => it.producto.codigo == prod.codigo)
          .fold(0, (s, it) => s + it.cantidad);
      final int available = prod.unidades - alreadyInCart;

      if (available <= 0) {
        await showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Sin existencias disponibles'),
            content: Text(
              'No hay existencias disponibles. Ya tienes $alreadyInCart en el carrito.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (unidades > available) {
        await showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Stock insuficiente'),
            content: Text(
              'No hay suficientes existencias. Solo quedan $available unidades disponibles.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Merge into cart if exists, otherwise add new
      final existingIndex = _items.indexWhere(
        (it) => it.producto.codigo == prod.codigo,
      );
      setState(() {
        if (existingIndex >= 0) {
          final old = _items[existingIndex];
          _items[existingIndex] = _FacturaItem(
            producto: old.producto,
            cantidad: old.cantidad + unidades,
          );
        } else {
          _items.add(_FacturaItem(producto: prod, cantidad: unidades));
        }

        _undsController.text = '1';
        _codigoController.clear();
      });
    } catch (e) {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error al obtener producto: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('OK'),
            ),
          ],
        ),
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
        title: Text("FACTURACION", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: form
            Informacion(),
            const SizedBox(width: 40),
            // Center: clock (smaller)
            SizedBox(width: 180, child: MinimalClockWidget(size: 180)),
            const SizedBox(width: 40),
            // Right: resumen de factura (items + totales)
            Expanded(flex: 1, child: _resumen()),
          ],
        ),
      ),
    );
  }

  Widget Informacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wrap ONLY the scrolling fields in an Expanded + ScrollView
        Expanded(
          child: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Textfieldfacturacion(
                    name: "Identificación (Cédula)",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    onChanged: (v) => _cedula = v,
                  ),
                  const SizedBox(height: 15),
                  Textfieldfacturacion(
                    name: "Nombre",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    onChanged: (v) => _nombreCliente = v,
                  ),
                  const SizedBox(height: 15),
                  Textfieldfacturacion(
                    name: "Apellido",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    onChanged: (v) => _apellidoCliente = v,
                  ),
                  const SizedBox(height: 15),
                  Dropdownformfield(
                    name: "Nacionalidad",
                    color: AppColors.buttonSecondary,
                    ancho: _ancho,
                    alto: _alto,
                    option: const ["Venezolano", "Extranjero", "Juridico"],
                    value: _nacionalidad,
                    onChanged: (v) {
                      if (v != null) setState(() => _nacionalidad = v);
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Textfieldfacturacion(
                          name: "Producto (código)",
                          color: AppColors.buttonSecondary,
                          ancho: 220,
                          alto: 60,
                          controller: _codigoController,
                          onFieldSubmitted: (_) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _buscarYAgregarProducto,
                        icon: Icon(
                          Icons.search,
                          color: AppColors.buttonSecondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 1,
                        child: Textfieldfacturacion(
                          name: "Unds.",
                          color: AppColors.buttonSecondary,
                          ancho: 110,
                          alto: 60,
                          controller: _undsController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // This part stays at the bottom
        const SizedBox(height: 20),
        Buttoncolor(
          name: "Agregar Producto",
          alto: 68,
          ancho: 350,
          color: AppColors.buttonSecondary,
          function: _agregarProductoDesdeCampos,
        ),
      ],
    );
  }

  Widget _resumen() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Productos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('No hay productos agregados.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final it = _items[index];
                      final prod = it.producto;
                      final precioTotal = it.total;

                      Widget imagenWidget() {
                        try {
                          if (prod.imagen == null ||
                              prod.imagen!.isEmpty ||
                              prod.imagen == 'sin_imagen') {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            );
                          }
                          return Image.memory(
                            base64Decode(prod.imagen!),
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          );
                        } catch (e) {
                          return const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.red,
                          );
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: imagenWidget(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prod.nombre ?? 'Sin nombre',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Unidades: ${it.cantidad}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${precioTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.positive,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _items.removeAt(index)),
                              icon: const Icon(Icons.delete_forever),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text('\$${_subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('IVA: 16%'),
              Text('\$${_iva.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:'),
              Text(
                '\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Buttoncolor(
            name: 'Pagar',
            alto: 50,
            ancho: 140,
            color: AppColors.positive,
            page: Placeholder(),
          ),
        ],
      ),
    );
  }
}

class _FacturaItem {
  final Producto producto;
  final int cantidad;
  double get total => producto.costo * producto.ganancia * cantidad;
  _FacturaItem({required this.producto, required this.cantidad});
}
