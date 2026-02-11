import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Buttonline extends StatefulWidget {
  final String name;
  final double alto;
  final double ancho;
  final Color color;
  final Widget page;
  final IconData icono;

  const Buttonline({
    super.key,
    required this.name,
    required this.alto,
    required this.ancho,
    required this.color,
    required this.page,
    required this.icono,
  });

  @override
  State<Buttonline> createState() => _ButtonlineState();
}

class _ButtonlineState extends State<Buttonline> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        overlayColor: WidgetStateProperty.all(
          // ignore: deprecated_member_use
          AppColors.secondary.withOpacity(0.2),
        ),
      ),
      child: Container(
        width: widget.ancho,
        height: widget.alto,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.secondary, width: 3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10), // Espacio entre texto e icono
            Icon(widget.icono, color: AppColors.buttonSecondary, size: 40.0),
          ],
        ),
      ),
    );
  }
}
