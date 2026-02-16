import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Fechafield extends StatefulWidget {
  final String name;
  final Color color;

  const Fechafield({super.key, required this.name, required this.color});

  @override
  State<Fechafield> createState() => _FechafieldState();
}

class _FechafieldState extends State<Fechafield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: TextStyles.bodyText),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
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
                  hintText: "DD",
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
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
                  hintText: "MM",
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
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
                  hintText: "YYYY",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
