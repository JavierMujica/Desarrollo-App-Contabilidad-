import 'dart:convert';
import 'package:desarrollo_de_software/core/estructura_db.dart';
import 'package:http/http.dart' as http;

class CategoriaService {
  // Cambia 'localhost' por 'localhost' si usas emulador de Android
  final String baseUrl = "http://localhost:8000";

  // --- FUNCIÓN PARA EL GET /Categoria (Obtener todas) ---
  Future<List<String>> obtenerCategorias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Categoria'));

      if (response.statusCode == 200) {
        // Según tu Swagger, el back responde con un "string" o lista de strings
        List<dynamic> datos = jsonDecode(response.body);
        return datos.map((e) => e.toString()).toList();
      } else {
        throw Exception("Error al obtener categorías: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // --- FUNCIÓN PARA EL POST /Categoria/{categoria} (Crear) ---
  // Nota: Según tu Swagger, el nombre de la categoría va en la URL (path parameter)
  Future<bool> crearCategoria(String nombreNuevaCategoria) async {
    try {
      // La URL se construye incluyendo el nombre al final
      final url = Uri.parse('$baseUrl/Categoria/$nombreNuevaCategoria');

      final response = await http.post(url);

      if (response.statusCode == 200) {
        print("Categoría creada con éxito");
        return true;
      } else {
        print("Error del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red: $e");
      return false;
    }
  }
}

class ClienteService {
  final String baseUrl = "http://localhost:8000"; // Cambia según tu entorno

  // 1. POST /Cliente (Crear)
  // Aquí enviamos un objeto JSON en el 'body'
  Future<bool> crearCliente(Cliente cliente) async {
    final url = Uri.parse('$baseUrl/Cliente');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );
    return response.statusCode == 200;
  }

  // 2. GET /Cliente (Obtener con filtros opcionales)
  // Los parámetros van después del signo '?' en la URL (Query Parameters)
  Future<List<Cliente>> obtenerClientes({String? id, String? nombre}) async {
    // Construimos la URL con parámetros si existen
    String query = "";
    if (id != null) query += "?id=$id";
    if (nombre != null) query += (query.isEmpty ? "?" : "&") + "nombre=$nombre";

    final response = await http.get(Uri.parse('$baseUrl/Cliente$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Cliente.fromJson(item)).toList();
    } else {
      throw Exception("Error al obtener clientes");
    }
  }

  // 3. PATCH /Cliente/{id}/{monto} (Actualizar)
  // Aquí los datos van directamente en la ruta (Path Parameters)
  Future<bool> actualizarMonto(String id, double nuevoMonto) async {
    final url = Uri.parse('$baseUrl/Cliente/$id/$nuevoMonto');
    final response = await http.patch(url);

    return response.statusCode == 200;
  }
}

class FacturaService {
  final String baseUrl = "http://localhost:8000"; // Tu IP local del emulador

  // 1. POST /Factura (Crear)
  Future<bool> crearFactura(Factura nuevaFactura) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Factura'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(nuevaFactura.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error al crear factura: $e");
      return false;
    }
  }

  // 2. PATCH /Factura/{id}/{Metodo} (Actualizar método de pago)
  // Fíjate que el id es un int según tu Swagger
  Future<bool> actualizarMetodoPago(int id, String nuevoMetodo) async {
    try {
      final url = Uri.parse('$baseUrl/Factura/$id/$nuevoMetodo');
      final response = await http.patch(url);

      return response.statusCode == 200;
    } catch (e) {
      print("Error al actualizar método: $e");
      return false;
    }
  }

  // 3. GET /Factura/{temporalidad} (Obtener facturas por periodo)
  // temporalidad es un integer (ej: 1 para diario, 30 para mensual, depende de la lógica del back)
  Future<List<Factura>> obtenerFacturas(int temporalidad) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Factura/$temporalidad'),
      );

      if (response.statusCode == 200) {
        // Asumiendo que el backend devuelve una lista JSON
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Factura.fromJson(item)).toList();
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}

class OrdenService {
  final String baseUrl =
      "http://localhost:8000"; // Ajusta a tu IP si usas dispositivo físico

  // 1. POST /Orden (Crear)
  Future<bool> crearOrden(Orden nuevaOrden) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Orden'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(nuevaOrden.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error al crear la orden: $e");
      return false;
    }
  }

  // 2. GET /Orden (Obtener con filtros opcionales)
  // Usa query parameters igual que hicimos con los Clientes
  Future<List<Orden>> obtenerOrdenes({
    int? temporalidad,
    String? producto,
  }) async {
    String query = "";

    // Construimos los parámetros de la URL
    if (temporalidad != null) query += "?temporalidad=$temporalidad";
    if (producto != null) {
      query += (query.isEmpty ? "?" : "&") + "producto=$producto";
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/Orden$query'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Orden.fromJson(item)).toList();
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  // 3. PUT /Orden/{ID} (Actualizar)
  // Ojo aquí: El PUT normalmente envía un JSON completo, pero según el Swagger
  // Diego lo configuró para que solo reciba el ID en la URL, sin body.
  Future<bool> actualizarOrden(int id) async {
    try {
      final url = Uri.parse('$baseUrl/Orden/$id');
      final response = await http.put(url); // Fíjate que usamos http.put

      return response.statusCode == 200;
    } catch (e) {
      print("Error al actualizar la orden: $e");
      return false;
    }
  }
}

class ProductoService {
  final String baseUrl = "http://localhost:8000"; // Tu IP del emulador

  // 1. POST /Producto (Crear)
  Future<bool> crearProducto(Producto nuevoProducto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Producto'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(nuevoProducto.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error al crear producto: $e");
      return false;
    }
  }

  // 2. GET /Producto (Obtener con filtros opcionales)
  Future<List<Producto>> obtenerProductos({
    String? codigo,
    String? categoria,
  }) async {
    String query = "";

    // Filtros en la URL
    if (codigo != null) query += "?codigo=$codigo";
    if (categoria != null) {
      query += (query.isEmpty ? "?" : "&") + "categoria=$categoria";
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/Producto$query'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Producto.fromJson(item)).toList();
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  // 3. PUT /Producto (Actualizar)
  // Fíjate que se envía TODO el objeto Producto en el body
  Future<bool> actualizarProducto(Producto productoActualizado) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Producto'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productoActualizado.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error al actualizar producto: $e");
      return false;
    }
  }

  // 4. DELETE /Producto/{codigo} (Eliminar)
  // Solo necesita el código en la URL, no lleva body
  Future<bool> eliminarProducto(String codigo) async {
    try {
      final url = Uri.parse('$baseUrl/Producto/$codigo');
      final response = await http.delete(url);

      return response.statusCode == 200;
    } catch (e) {
      print("Error al eliminar producto: $e");
      return false;
    }
  }
}

class ProveedorService {
  final String baseUrl = "http://localhost:8000"; // Ajusta a tu entorno local

  // 1. GET /Proveedor (Obtener con filtros opcionales)
  // Nota: Swagger pide Nombre, Apellido y cedula (minúscula)
  Future<List<Proveedor>> obtenerProveedores({
    String? nombre,
    String? apellido,
    String? cedula,
  }) async {
    String query = "";
    List<String> params = [];

    if (nombre != null) params.add("Nombre=$nombre");
    if (apellido != null) params.add("Apellido=$apellido");
    if (cedula != null) params.add("cedula=$cedula"); // minúscula aquí

    if (params.isNotEmpty) {
      query = "?" + params.join("&");
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/Proveedor$query'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Proveedor.fromJson(item)).toList();
      } else {
        throw Exception("Error al obtener proveedores: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  // 2. POST /Proveedor (Crear)
  Future<bool> crearProveedor(Proveedor nuevoProveedor) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Proveedor'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(nuevoProveedor.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error al crear proveedor: $e");
      return false;
    }
  }

  // 3. PUT /Proveedor (Actualizar)
  Future<bool> actualizarProveedor(Proveedor proveedorActualizado) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Proveedor'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(proveedorActualizado.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error al actualizar proveedor: $e");
      return false;
    }
  }

  // 4. DELETE /Proveedor/{cedula} (Eliminar)
  Future<bool> eliminarProveedor(String cedula) async {
    try {
      // La cédula va directamente en la URL
      final url = Uri.parse('$baseUrl/Proveedor/$cedula');
      final response = await http.delete(url);

      return response.statusCode == 200;
    } catch (e) {
      print("Error al eliminar proveedor: $e");
      return false;
    }
  }
}
