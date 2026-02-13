import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Buttoncolor extends StatefulWidget {
  final String name;
  final double ancho;
  final double alto;
  final Widget page;
  final Color color;
  const Buttoncolor({
    super.key,
    required this.alto,
    required this.ancho,
    required this.name,
    required this.page,
    required this.color,
  });

  @override
  State<Buttoncolor> createState() => _ButtoncolorState();
}

class _ButtoncolorState extends State<Buttoncolor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.alto,
      width: widget.ancho,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.page),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(widget.color),
        ),
        child: Text(widget.name, style: TextStyles.bodyButton),
      ),
    );
  }
}
