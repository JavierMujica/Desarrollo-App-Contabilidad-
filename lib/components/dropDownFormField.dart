import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Dropdownformfield extends StatefulWidget {
  final double ancho;
  final double alto;
  final Color color;
  final List<String> option;
  final String name;
  const Dropdownformfield({
    super.key,
    required this.color,
    required this.alto,
    required this.ancho,
    required this.option,
    required this.name,
  });

  @override
  State<Dropdownformfield> createState() => _DropdownformfieldState();
}

class _DropdownformfieldState extends State<Dropdownformfield> {
  String? _valorSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: TextStyles.bodyText),
        SizedBox(
          width: widget.ancho,
          height: widget.alto,
          child: DropdownButtonFormField<String>(
            hint: Text(
              "Seleccionar",
              style: TextStyle(
                decorationColor: widget.color,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            value: _valorSeleccionado ?? 'Seleccionar',
            style: TextStyle(
              decorationColor: widget.color,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  AppColors.primary, // Ese gris azulado muy suave de tu imagen
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              // Línea inferior cuando no está seleccionado
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1.5),
              ),
              // Línea inferior azul cuando haces clic (como en tu imagen)
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1.5),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _valorSeleccionado = newValue!;
              });
            },
            items: [
              // 1. Agregamos el item fijo manualmente
              const DropdownMenuItem(
                value: 'Seleccionar',
                child: Text('Seleccionar'),
              ),
              // 2. Esparcimos los N items de tu lista dinámica
              ...widget.option.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
