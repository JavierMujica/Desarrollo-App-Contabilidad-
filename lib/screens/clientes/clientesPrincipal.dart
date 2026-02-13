import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:flutter/material.dart';

class ClientesPrincipal extends StatefulWidget {
  const ClientesPrincipal({super.key});

  @override
  State<ClientesPrincipal> createState() => _ClientesPrincipalState();
}

class _ClientesPrincipalState extends State<ClientesPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("CLIENTES", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
  }
}
