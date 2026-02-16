import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class Buttonserch extends StatefulWidget {
  final Widget page;
  const Buttonserch({super.key, required this.page});

  @override
  State<Buttonserch> createState() => _ButtonserchState();
}

class _ButtonserchState extends State<Buttonserch> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },
      icon: Icon(Icons.search, color: AppColors.buttonSecondary, size: 30),
    );
  }
}
