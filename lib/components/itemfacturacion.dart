import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Itemfacturacion extends StatefulWidget {
  final String name;
  final double amount;
  final double price;
  final Function accion;

  const Itemfacturacion({
    super.key,
    required this.name,
    required this.amount,
    required this.price,
    required this.accion,
  });

  @override
  State<Itemfacturacion> createState() => _ItemfacturacionState();
}

class _ItemfacturacionState extends State<Itemfacturacion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white, // Color de fondo
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(widget.name, style: TextStyles.bodyText),
              Text("Unidades: ${widget.amount}", style: TextStyles.bodyButton),
            ],
          ),
          Text("\$${widget.price}", style: TextStyles.bodyButton),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/lado-del-camion.png",
              width: 30,
              height: 30,
              color: AppColors.negative,
            ),
          ),
        ],
      ),
    );
  }
}
