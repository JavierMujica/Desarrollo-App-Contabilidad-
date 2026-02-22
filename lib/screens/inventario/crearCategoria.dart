import 'package:flutter/material.dart';
import 'package:desarrollo_de_software/components/buttonColor.dart';
import 'package:desarrollo_de_software/components/textFieldFacturacion.dart';
import 'package:desarrollo_de_software/core/appdesing.dart';
import 'package:desarrollo_de_software/core/conexion_db.dart'; // Aquí asumo que tienes tu CategoriaService

class Crearcategoria extends StatefulWidget {
  const Crearcategoria({super.key});

  @override
  State<Crearcategoria> createState() => _CrearcategoriaState();
}

class _CrearcategoriaState extends State<Crearcategoria> {
  // 1. EL RECOLECTOR Y CONTROLADORES VISUALES
  Map<String, dynamic> formulario = {};
  int _resetKey = 0; // Para limpiar el TextField después de guardar

  // 2. EL FUTURO PARA LA LISTA DE LA DERECHA
  late Future<List<String>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _cargarCategorias(); // Pedimos las categorías al abrir la pantalla
  }

  // Función para refrescar la lista
  void _cargarCategorias() {
    _futureCategorias = CategoriaService().obtenerCategorias();
  }

  // 3. LA FUNCIÓN DE GUARDADO
  void _guardarCategoria() async {
    String nombreNuevaCategoria = formulario["Categoria"] ?? "";

    if (nombreNuevaCategoria.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingresa el nombre de la categoría"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final api = CategoriaService();
      bool exito = await api.crearCategoria(nombreNuevaCategoria);

      if (exito) {
        setState(() {
          formulario.clear(); // Vaciamos el recolector
          _resetKey++; // Limpiamos el textfield visualmente
          _cargarCategorias(); // ¡Magia! Recargamos la lista automáticamente
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Categoría creada exitosamente!"),
            backgroundColor: Color(0xFF10B981), // Tu verde de éxito
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo crear la categoría"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text("GESTIÓN DE CATEGORÍAS", style: TextStyles.bodyButton),
        centerTitle: true,
      ),
      body: Row(
        key: ValueKey(_resetKey), // Para limpiar los campos al guardar
        children: [
          // --- COLUMNA IZQUIERDA: EL FORMULARIO (40%) ---
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Nueva Categoría",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Textfieldfacturacion(
                          name: "Nombre de la Categoría",
                          color: AppColors.secondary,
                          alto: 52,
                          ancho: 350,
                          onChanged: (valor) => formulario["Categoria"] = valor,
                        ),
                        const SizedBox(height: 40),
                        Buttoncolor(
                          alto: 60,
                          ancho: 350,
                          name: "Guardar Categoría",
                          color: AppColors.buttonSecondary,
                          function: _guardarCategoria,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- COLUMNA DERECHA: LA LISTA (60%) ---
          Expanded(
            flex: 6,
            child: Container(
              color: const Color(0xFFF8F9FA), // Fondo blanco/gris claro
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categorías Existentes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<String>>(
                      future: _futureCategorias,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error al cargar categorías",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aún no hay categorías creadas.",
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        List<String> categorias = snapshot.data!;
                        return ListView.builder(
                          itemCount: categorias.length,
                          itemBuilder: (context, index) {
                            return _tarjetaCategoria(categorias[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Diseño de cada elemento de la lista
  Widget _tarjetaCategoria(String nombreCategoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: AppColors
                .buttonSecondary, // Una línea decorativa a la izquierda
            width: 5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: AppColors.secondary, size: 30),
          const SizedBox(width: 20),
          Text(
            nombreCategoria,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
