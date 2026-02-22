import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Fechafield extends StatefulWidget {
  final String name;
  final Color color;
  // NUEVO: Permite enviar la fecha ensamblada hacia afuera
  final ValueChanged<String>? onChanged;

  const Fechafield({
    super.key,
    required this.name,
    required this.color,
    this.onChanged, // NUEVO
  });

  @override
  State<Fechafield> createState() => _FechafieldState();
}

class _FechafieldState extends State<Fechafield> {
  // Controladores para leer cada cajita
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();

  // Función que ensambla la fecha y la envía
  void _notificarCambio() {
    if (widget.onChanged != null) {
      // padLeft(2, '0') hace que si escribes "5", se convierta en "05"
      String dia = _diaController.text.padLeft(2, '0');
      String mes = _mesController.text.padLeft(2, '0');
      String anio = _anioController.text.padLeft(4, '0');

      // Solo armamos la fecha si el usuario ya escribió algo en los 3 campos
      if (_diaController.text.isNotEmpty &&
          _mesController.text.isNotEmpty &&
          _anioController.text.isNotEmpty) {
        // Ensamblamos en formato YYYY-MM-DD para la API de FastAPI
        String fechaEnsamblada = "$anio-$mes-$dia";
        widget.onChanged!(fechaEnsamblada);
      }
    }
  }

  @override
  void dispose() {
    // Es buena práctica limpiar los controladores al cerrar la pantalla
    _diaController.dispose();
    _mesController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: TextStyles.bodyText),
        Row(
          children: [
            // --- CAMPO DÍA ---
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
                controller: _diaController,
                keyboardType: TextInputType.number, // Teclado numérico
                maxLength: 2, // Máximo 2 números
                onChanged: (valor) => _notificarCambio(), // Avisa cuando cambia
                style: TextStyle(
                  decorationColor: widget.color,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  counterText: "", // Oculta el contador de letras (0/2)
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 3),
                  ),
                  hintText: "DD",
                ),
              ),
            ),
            const SizedBox(width: 10),

            // --- CAMPO MES ---
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
                controller: _mesController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                onChanged: (valor) => _notificarCambio(),
                style: TextStyle(
                  decorationColor: widget.color,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 3),
                  ),
                  hintText: "MM",
                ),
              ),
            ),
            const SizedBox(width: 10),

            // --- CAMPO AÑO ---
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
                controller: _anioController,
                keyboardType: TextInputType.number,
                maxLength: 4, // Máximo 4 números (2026)
                onChanged: (valor) => _notificarCambio(),
                style: TextStyle(
                  decorationColor: widget.color,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1.5),
                  ),
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
