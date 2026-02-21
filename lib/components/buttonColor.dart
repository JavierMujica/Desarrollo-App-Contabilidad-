import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Buttoncolor extends StatelessWidget {
  final String name;
  final double ancho;
  final double alto;
  final Widget? page;
  final Color color;
  final VoidCallback? function;

  const Buttoncolor({
    super.key,
    required this.alto,
    required this.ancho,
    required this.name,
    this.page,
    required this.color,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: alto,
      width: ancho,
      child: ElevatedButton(
        onPressed: () {
          if (function != null) {
            function!();
          }
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page!),
            );
          }
        },
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
        child: Text(name, style: TextStyles.bodyButton),
      ),
    );
  }
}
