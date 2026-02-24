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
  final TextEditingController? controller;

  const Textfieldfacturacion({
    super.key,
    required this.name,
    required this.color,
    required this.alto,
    required this.ancho,
    this.onChanged,
    this.initialValue,
    this.onFieldSubmitted,
    this.controller,
  });

  @override
  State<Textfieldfacturacion> createState() => _TextfieldfacturacionState();
}

class _TextfieldfacturacionState extends State<Textfieldfacturacion> {
  late TextEditingController _internalController;
  bool _usingInternal = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _internalController = widget.controller!;
      _usingInternal = false;
    } else {
      _internalController = TextEditingController(text: widget.initialValue ?? '');
      _usingInternal = true;
    }
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
          //color: Colors.amber,
          child: TextFormField(
            controller: _internalController,
            onFieldSubmitted: widget.onFieldSubmitted,
            textInputAction: TextInputAction.search,

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

  @override
  void didUpdateWidget(covariant Textfieldfacturacion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent starts providing a controller, switch to it
    if (oldWidget.controller == null && widget.controller != null) {
      // Transfer text to the new controller
      try {
        widget.controller!.text = _internalController.text;
      } catch (_) {}
      if (_usingInternal) {
        try {
          _internalController.dispose();
        } catch (_) {}
      }
      _internalController = widget.controller!;
      _usingInternal = false;
      return;
    }

    // If the parent removed the controller, create an internal one and copy text
    if (oldWidget.controller != null && widget.controller == null) {
      _internalController = TextEditingController(text: oldWidget.controller!.text);
      _usingInternal = true;
      return;
    }

    // If the parent changed initialValue and we're using internal controller, update it
    if (_usingInternal && widget.initialValue != null && widget.initialValue != _internalController.text) {
      _internalController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    try {
      if (_usingInternal) _internalController.dispose();
    } catch (_) {}
    super.dispose();
  }
}
