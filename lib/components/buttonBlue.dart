import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Buttonblue extends StatefulWidget {
  final String name;
  final double ancho;
  final double alto;
  const Buttonblue({
    super.key,
    required this.alto,
    required this.ancho,
    required this.name,
  });

  @override
  State<Buttonblue> createState() => _ButtonblueState();
}

class _ButtonblueState extends State<Buttonblue> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.alto,
      width: widget.ancho,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.buttonSecondary),
        ),
        child: Text(widget.name, style: TextStyles.bodyButton),
      ),
    );
  }
}
