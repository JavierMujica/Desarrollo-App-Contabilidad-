import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/fechaField.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/screens/buscarProduccto.dart';
import 'package:flutter/material.dart';

class Ordenregistrar extends StatefulWidget {
  const Ordenregistrar({super.key});

  @override
  State<Ordenregistrar> createState() => _OrdenregistrarState();
}

class _OrdenregistrarState extends State<Ordenregistrar> {
  // 1. EL RECOLECTOR GENERAL Y VARIABLES UI
  Map<String, dynamic> formulario = {};
  int _resetKey = 0;
  bool _mostrarExito = false;

  // --- NUEVO: Candado para evitar el doble registro ---
  bool _estaGuardando = false;

  // Variable para guardar el producto que estamos actualizando
  Producto? _productoSeleccionado;

  // --- FUNCIÓN 1: BUSCAR DIRECTAMENTE POR CÓDIGO (Al dar Enter) ---
  void _buscarPorCodigo() async {
    String codigo = formulario["Producto"] ?? "";
    if (codigo.isEmpty) return;

    try {
      final api = ProductoService();
      List<Producto> resultados = await api.obtenerProductos(codigo: codigo);

      if (resultados.isNotEmpty) {
        setState(() {
          _productoSeleccionado = resultados.first;
          formulario["Producto"] = _productoSeleccionado!.codigo;
          formulario["Costo-Unidad"] = _productoSeleccionado!.costo.toString();

          _resetKey++;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Producto '${_productoSeleccionado!.nombre}' seleccionado.",
            ),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se encontró el producto."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error buscando: $e");
    }
  }

  // --- FUNCIÓN 2: ABRIR LA PANTALLA DE BÚSQUEDA POR NOMBRE ---
  void _abrirBusquedaPorNombre() async {
    final codigoSeleccionado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuscarProducto()),
    );

    if (codigoSeleccionado != null) {
      setState(() {
        formulario["Producto"] = codigoSeleccionado;
      });
      _buscarPorCodigo();
    }
  }

  // --- FUNCIÓN 3: ENVIAR DATOS (Crear la Orden SIN tocar el inventario) ---
  void _enviarDatos() async {
    // 1. Si ya se está guardando, ignoramos los clics extra
    if (_estaGuardando) return;

    if (_productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Primero debes seleccionar un producto."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      int nuevasUnidades = int.tryParse(formulario["Unidades"] ?? "0") ?? 0;
      double nuevoCosto =
          double.tryParse(formulario["Costo-Unidad"] ?? "0") ??
          _productoSeleccionado!.costo;

      String fechaLlegada = formulario["Fecha-Tentativa"] ?? "2026-12-31";

      if (nuevasUnidades <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Debes ingresar una cantidad válida mayor a cero."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // 2. Activamos el candado
      setState(() {
        _estaGuardando = true;
      });

      // 3. Creamos el objeto Orden en estado "Pendiente" (Recibida: false)
      final nuevaOrden = Orden(
        id: 0,
        producto: _productoSeleccionado!.codigo,
        cantidad: nuevasUnidades,
        fechaLlegada: fechaLlegada,
        costo: nuevoCosto,
        recibida: false, // ESTO GARANTIZA QUE EL INVENTARIO NO SUBA AÚN
      );

      // 4. Enviamos a la base de datos
      final api = OrdenService();
      bool exito = await api.crearOrden(nuevaOrden);

      if (exito) {
        // Conservamos una referencia al producto antes de limpiar el estado
        final productoAnterior = _productoSeleccionado;

        // Si el costo cambiado es distinto al actual, intentamos actualizar el producto
        if (productoAnterior != null && nuevoCosto != productoAnterior.costo) {
          try {
            final productoApi = ProductoService();
            final actualizado = Producto(
              nombre: productoAnterior.nombre,
              categoria: productoAnterior.categoria,
              ganancia: productoAnterior.ganancia,
              costo: nuevoCosto,
              proveedor: productoAnterior.proveedor,
              codigo: productoAnterior.codigo,
              limiteExistencia: productoAnterior.limiteExistencia,
              unidades: productoAnterior.unidades,
              imagen: productoAnterior.imagen ?? 'sin_imagen',
            );

            bool actualizo = await productoApi.actualizarProducto(actualizado);
            if (actualizo) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Costo de producto actualizado."),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No se pudo actualizar el costo del producto."),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } catch (e) {
            print("Error actualizando producto: $e");
          }
        }

        setState(() {
          formulario.clear();
          _productoSeleccionado = null;
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al registrar la orden en la BD."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error guardando orden: $e");
    } finally {
      // 5. Pase lo que pase (éxito o error), quitamos el candado
      if (mounted) {
        setState(() {
          _estaGuardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("NUEVA ORDEN", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        key: ValueKey(_resetKey),
        children: [
          // --- COLUMNA IZQUIERDA: EL FORMULARIO ---
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 40,
                right: 40,
                bottom: 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Textfieldfacturacion(
                        name: "Código del Producto",
                        color: AppColors.secondary,
                        alto: 52,
                        ancho: 250,
                        initialValue: formulario["Producto"],
                        onChanged: (valor) => formulario["Producto"] = valor,
                        onFieldSubmitted: (valor) => _buscarPorCodigo(),
                      ),
                      const SizedBox(width: 10),
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
                          onPressed: _abrirBusquedaPorNombre,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Textfieldfacturacion(
                    name: "Unidades a ingresar",
                    color: AppColors.secondary,
                    alto: 52,
                    ancho: 315,
                    initialValue: formulario["Unidades"],
                    onChanged: (valor) => formulario["Unidades"] = valor,
                  ),
                  const SizedBox(height: 40),

                  Textfieldfacturacion(
                    name: "Costo por Unidad",
                    color: AppColors.secondary,
                    alto: 52,
                    ancho: 315,
                    initialValue: formulario["Costo-Unidad"],
                    onChanged: (valor) => formulario["Costo-Unidad"] = valor,
                  ),
                  const SizedBox(height: 40),

                  Fechafield(
                    name: "Fecha Tentativa de Llegada",
                    color: AppColors.secondary,
                    onChanged: (valor) => formulario["Fecha-Tentativa"] = valor,
                  ),

                  const Spacer(),

                  // El botón ahora cambiará ligeramente si está cargando para que el usuario lo note
                  _estaGuardando
                      ? const Center(child: CircularProgressIndicator())
                      : Buttoncolor(
                          alto: 58,
                          ancho: 315,
                          name: "Registrar Orden",
                          color: AppColors.buttonSecondary,
                          function: _enviarDatos,
                        ),
                ],
              ),
            ),
          ),

          // --- COLUMNA DERECHA: ANIMACIÓN DE ÉXITO ---
          Expanded(
            flex: 5,
            child: Center(
              child: AnimatedOpacity(
                opacity: _mostrarExito ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons
                          .local_shipping, // Ícono de un camión de orden pendiente
                      color: AppColors.buttonSecondary,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "¡Orden Creada!",
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
