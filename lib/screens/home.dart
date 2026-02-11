import 'package:desarrollo_de_software/components/button_home.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/clock.dart';
import 'package:desarrollo_de_software/screens/clientes/clientesPrincipal.dart';
import 'package:desarrollo_de_software/screens/facturacion/facturacionPrincipal.dart';
import 'package:desarrollo_de_software/screens/inventario/inventarioPrincipal.dart';
import 'package:desarrollo_de_software/screens/ordene/ordenPrincipal.dart';
import 'package:desarrollo_de_software/screens/proveedores/proveedorPrincipal.dart';
import 'package:desarrollo_de_software/screens/reportes/reportesPrincipal.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double altura = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("MODULOS", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, top: 30, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonHome(
                  name: "Facturación",
                  nameImage: "assets/images/carrito-de-compras.png",
                  page: Facturacionprincipal(),
                ),
                ButtonHome(
                  name: "Inventario",
                  nameImage: "assets/images/comprobacion-de-lista.png",
                  page: Inventarioprincipal(),
                ),
                ButtonHome(
                  name: "Reportes",
                  nameImage: "assets/images/grafico-histograma.png",
                  page: Reportesprincipal(),
                ),
                ButtonHome(
                  name: "Ordenes",
                  nameImage: "assets/images/editar.png",
                  page: Ordenprincipal(),
                ),
                ButtonHome(
                  name: "Proveedores",
                  nameImage: "assets/images/lado-del-camion.png",
                  page: Proveedorprincipal(),
                ),
                ButtonHome(
                  name: "Clientes",
                  nameImage: "assets/images/usuario.png",
                  page: ClientesPrincipal(),
                ),
              ],
            ),
          ),
          const Expanded(flex: 1, child: MinimalClockWidget()),
        ],
      ),
    );
  }
}
