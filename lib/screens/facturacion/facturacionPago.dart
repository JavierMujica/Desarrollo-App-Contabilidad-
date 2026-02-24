// Pantalla de Pago para facturación
import 'package:flutter/material.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart';

class FacturacionPago extends StatefulWidget {
  final String nombreCliente;
  final String cedula;
  final String numeroFactura;
  final double monto; // monto en USD (según FacturacionPrincipal)
  final List<DetalleFactura> detalles;

  const FacturacionPago({
    super.key,
    required this.nombreCliente,
    required this.cedula,
    required this.numeroFactura,
    required this.monto,
    required this.detalles,
  });

  @override
  State<FacturacionPago> createState() => _FacturacionPagoState();
}

class _FacturacionPagoState extends State<FacturacionPago> {
  String _metodo = 'Efectivo';

  // Ejemplo: factor de conversión USD -> Bs (puedes obtenerlo externamente)
  double _factorBs = 370.0;

  bool _loading = false;
  bool _showSuccess = false;

  Future<void> _procesarPago() async {
    setState(() => _loading = true);

    final factura = Factura(
      cliente: widget.cedula,
      detalles: widget.detalles,
      monto: widget.monto,
      vendedor: 'Admin',
      metodo: _metodo,
      pagada: true,
    );

    final createdIdStr = await FacturaService().crearFactura(factura);

    setState(() {
      _loading = false;
    });

    if (createdIdStr != null) {
      // Intentar marcar la factura como pagada para que el backend actualice inventario
      final intId = int.tryParse(createdIdStr) ?? 0;
      bool updateOk = false;
      if (intId > 0) {
        updateOk = await FacturaService().actualizarMetodoPago(intId, _metodo);
      }

      if (updateOk) {
        // Guardar/actualizar información del cliente en la tabla cliente
        try {
          final parts = widget.nombreCliente.split(' ');
          final nombre = parts.isNotEmpty ? parts.first : widget.nombreCliente;
          final apellido = parts.length > 1 ? parts.sublist(1).join(' ') : '';

          final cliente = Cliente(
            nombre: nombre,
            apellido: apellido,
            nacionalidad: 'Venezolano',
            identificacion: widget.cedula,
            montoHistorico: widget.monto,
          );

          // Intentar crear; si ya existe, crearCliente devolverá false
          final creado = await ClienteService().crearCliente(cliente);
          // Si no se creó (ya existía), sumar el monto histórico
          if (!creado) {
            await ClienteService().actualizarMonto(widget.cedula, widget.monto);
          }
        } catch (_) {}

        setState(() => _showSuccess = true);
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (mounted) Navigator.pop(context, true);
        });
        return;
      }

      // Si no pudo marcar como pagada, mostrar error
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Factura creada pero no se pudo completar el pago. Intente nuevamente.'),
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

    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Error'),
        content: const Text('No fue posible guardar la factura.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _metodoButton(String metodo, IconData icon) {
    final selected = _metodo == metodo;
    return GestureDetector(
      onTap: () => setState(() => _metodo = metodo),
      child: Column(
        children: [
          Icon(icon, size: 44, color: selected ? AppColors.secondary : Colors.black87),
          const SizedBox(height: 8),
          Text(metodo, style: TextStyle(color: selected ? AppColors.secondary : Colors.black87)),
          const SizedBox(height: 6),
          Container(height: 3, width: 80, color: selected ? AppColors.secondary : Colors.transparent),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final montoBs = (widget.monto * _factorBs);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: const Text('Pago', style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      children: [
                        // Left info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Factura: ${widget.numeroFactura}', style: TextStyles.titleStyle.copyWith(fontSize: 22, color: AppColors.secondary)),
                              const SizedBox(height: 14),
                              Text('Cliente: ${widget.cedula}', style: TextStyles.bodyText.copyWith(fontSize: 18, color: AppColors.secondary)),
                              const SizedBox(height: 6),
                              Text(widget.nombreCliente, style: TextStyles.bodyText.copyWith(fontSize: 18, color: AppColors.secondary)),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Text('Monto: ', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                  Text('\$ ${widget.monto.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 12),
                                  Text('Bs ${montoBs.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Center methods
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _metodoButton('Efectivo', Icons.attach_money),
                                  _metodoButton('Tarjeta', Icons.credit_card),
                                  _metodoButton('Pago Movil', Icons.smartphone),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 140,
                                  height: 46,
                                  child: _loading
                                      ? const Center(child: CircularProgressIndicator())
                                      : ElevatedButton(
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.positive)),
                                          onPressed: _procesarPago,
                                          child: const Text('Pagado', style: TextStyle(color: Colors.white)),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Overlay de éxito: pantalla blanca con caja centrada
          if (_showSuccess)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _showSuccess ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 88, color: AppColors.positive),
                              const SizedBox(height: 16),
                              Text('Pago Aprobado', style: TextStyle(fontSize: 22, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
