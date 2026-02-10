import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class ButtonHome extends StatefulWidget {
  final String name;
  final String nameImage;
  final Widget page;

  const ButtonHome({
    super.key,
    required this.name,
    required this.nameImage,
    required this.page,
  });

  @override
  State<ButtonHome> createState() => _ButtonHomeState();
}

class _ButtonHomeState extends State<ButtonHome> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },

      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        overlayColor: WidgetStateProperty.all(
          // ignore: deprecated_member_use
          AppColors.secondary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Image.asset(widget.nameImage, height: 60, width: 60),
          SizedBox(width: 15),
          Text(widget.name, style: TextStyles.bodyText),
        ],
      ),
    );
  }
}
