import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Itemorden extends StatefulWidget {
  final String name;
  final String nameProveedor;
  final double amount;
  final String fecha;
  final String estado;
  final int numeroOrden;

  const Itemorden({
    super.key,
    required this.name,
    required this.nameProveedor,
    required this.amount,
    required this.fecha,
    required this.estado,
    required this.numeroOrden,
  });

  @override
  State<Itemorden> createState() => _ItemordenState();
}

class _ItemordenState extends State<Itemorden> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.name}\nProveedor: ${widget.nameProveedor}\nUnidades: ${widget.amount}\nFecha de Entrega: ${widget.nameProveedor}\nEstador: ${widget.estado}\nOrden: #${widget.numeroOrden}",
          style: TextStyles.bodyButton,
        ),
      ],
    );
  }
}
