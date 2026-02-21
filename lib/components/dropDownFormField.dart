import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Dropdownformfield extends StatefulWidget {
  final double ancho;
  final double alto;
  final Color color;
  final List<String> option;
  final String name;
  final ValueChanged<String?>? onChanged;
  final String? value;

  const Dropdownformfield({
    super.key,
    required this.color,
    required this.alto,
    required this.ancho,
    required this.option,
    required this.name,
    this.onChanged,
    this.value,
  });

  @override
  State<Dropdownformfield> createState() => _DropdownformfieldState();
}

class _DropdownformfieldState extends State<Dropdownformfield> {
  String? _valorSeleccionado;

  @override
  void initState() {
    super.initState();
    // 1. IMPORTANTE: Inicializamos el estado interno con el valor que viene de la pantalla principal
    _valorSeleccionado = widget.value;
  }

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
              fillColor: AppColors.primary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1.5),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _valorSeleccionado = newValue;
              });

              // 2. ¡EL PUENTE MÁGICO!
              // Si la pantalla principal nos pasó la función onChanged, la ejecutamos
              // pasándole el nuevo valor para que lo guarde en el mapa de la BD.
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            items: [
              const DropdownMenuItem(
                value: 'Seleccionar',
                child: Text('Seleccionar'),
              ),
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
