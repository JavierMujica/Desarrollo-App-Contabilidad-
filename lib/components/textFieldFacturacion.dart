import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Textfieldfacturacion extends StatefulWidget {
  final String name;
  final Color color;
  final double ancho;
  final double alto;
  final Function(String)? onChanged;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;

  const Textfieldfacturacion({
    super.key,
    required this.name,
    required this.color,
    required this.alto,
    required this.ancho,
    this.onChanged,
    this.initialValue,
    this.onFieldSubmitted,
  });

  @override
  State<Textfieldfacturacion> createState() => _TextfieldfacturacionState();
}

class _TextfieldfacturacionState extends State<Textfieldfacturacion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: TextStyles.bodyText),
        SizedBox(
          width: widget.ancho,
          height: widget.alto,
          //color: Colors.amber,
          child: TextFormField(
            onFieldSubmitted: widget.onFieldSubmitted,
            textInputAction: TextInputAction.search,
            initialValue: widget.initialValue,

            style: TextStyle(
              decorationColor: widget.color,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              // Color de la línea cuando NO está seleccionado
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1.5),
              ),
              // Color de la línea cuando EL USUARIO HACE CLIC
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 3),
              ),
              hintText: null,
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
