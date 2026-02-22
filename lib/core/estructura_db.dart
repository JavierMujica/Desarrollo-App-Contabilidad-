class Cliente {
  final String nombre;
  final String apellido;
  final String nacionalidad;
  final String identificacion;
  final double montoHistorico;

  Cliente({
    required this.nombre,
    required this.apellido,
    required this.nacionalidad,
    required this.identificacion,
    required this.montoHistorico,
  });

  // Para enviar al backend (POST)
  Map<String, dynamic> toJson() => {
    "Nombre": nombre,
    "Apellido": apellido,
    "Nacionalidad": nacionalidad,
    "Identificacion": identificacion,
    "MontoHistorico": montoHistorico,
  };

  // Para recibir del backend (GET)
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombre: json['Nombre'],
      apellido: json['Apellido'],
      nacionalidad: json['Nacionalidad'],
      identificacion: json['Identificacion'],
      montoHistorico: json['MontoHistorico'].toDouble(),
    );
  }
}

// Modelo para cada producto dentro de la factura
class DetalleFactura {
  final String producto;
  final int cantidad;

  DetalleFactura({required this.producto, required this.cantidad});

  // Convertir a JSON
  Map<String, dynamic> toJson() => {"Producto": producto, "Cantidad": cantidad};

  // Recibir del backend
  factory DetalleFactura.fromJson(Map<String, dynamic> json) {
    return DetalleFactura(
      producto: json['Producto'],
      cantidad: json['Cantidad'],
    );
  }
}

// Modelo principal de la Factura
class Factura {
  final String cliente;
  final List<DetalleFactura> detalles; // Aquí está la lista anidada
  final double monto;
  final String vendedor;
  final String metodo;
  final bool pagada;

  Factura({
    required this.cliente,
    required this.detalles,
    required this.monto,
    required this.vendedor,
    required this.metodo,
    required this.pagada,
  });

  Map<String, dynamic> toJson() => {
    "Cliente": cliente,
    // Aquí mapeamos cada detalle a su formato JSON
    "Detalles": detalles.map((detalle) => detalle.toJson()).toList(),
    "Monto": monto,
    "Vendedor": vendedor,
    "Metodo": metodo,
    "Pagada": pagada,
  };

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      cliente: json['Cliente'],
      // Reconstruimos la lista de detalles
      detalles: (json['Detalles'] as List)
          .map((item) => DetalleFactura.fromJson(item))
          .toList(),
      monto: json['Monto'].toDouble(),
      vendedor: json['Vendedor'],
      metodo: json['Metodo'],
      pagada: json['Pagada'],
    );
  }
}

class Orden {
  final int id;
  final String producto;
  final int cantidad;
  final String fechaLlegada;
  final double costo;
  final bool recibida;

  Orden({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.fechaLlegada,
    required this.costo,
    required this.recibida,
  });

  // Convertir a JSON para el POST
  Map<String, dynamic> toJson() => {
    "ID": id,
    "Producto": producto,
    "Cantidad": cantidad,
    "FechaLlegada": fechaLlegada,
    "Costo": costo,
    "Recibida": recibida,
  };

  // Recibir del backend en el GET
  factory Orden.fromJson(Map<String, dynamic> json) {
    return Orden(
      // Fíjate bien en las mayúsculas exactas del JSON de FastAPI
      id: json['ID'] ?? 0,
      producto: json['Producto'] ?? 'Desconocido',
      cantidad: json['Cantidad'] ?? 0,
      fechaLlegada: json['FechaLlegada'] ?? 'Sin fecha',
      costo: (json['Costo'] ?? 0.0).toDouble(),
      recibida: json['Recibida'] ?? false,
    );
  }
}

class Producto {
  final String nombre;
  final String categoria;
  final double ganancia;
  final double costo;
  final String proveedor;
  final String codigo;
  final int limiteExistencia;
  final int unidades;
  final String? imagen; // Probablemente sea una URL o un texto en Base64

  Producto({
    required this.nombre,
    required this.categoria,
    required this.ganancia,
    required this.costo,
    required this.proveedor,
    required this.codigo,
    required this.limiteExistencia,
    required this.unidades,
    this.imagen,
  });

  // Convertir a JSON para el POST y PUT
  Map<String, dynamic> toJson() => {
    "Nombre": nombre,
    "Categoria": categoria,
    "Ganancia": ganancia,
    "Costo": costo,
    "Proveedor": proveedor,
    "Codigo": codigo,
    "LimiteExistencia": limiteExistencia,
    "Unidades": unidades,
    // Evitar enviar null: usar marcador "sin_imagen" cuando no haya imagen
    "Imagen": imagen ?? "sin_imagen",
  };

  // Recibir del backend en el GET
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      nombre: json['Nombre'],
      categoria: json['Categoria'],
      ganancia: json['Ganancia'].toDouble(),
      costo: json['Costo'].toDouble(),
      proveedor: json['Proveedor'],
      codigo: json['Codigo'],
      limiteExistencia: json['LimiteExistencia'],
      unidades: json['Unidades'],
      imagen: json['Imagen'],
    );
  }
}

class Proveedor {
  final String nombre;
  final String apellido;
  final String cedula;
  final String numeroContacto;
  final String correoContacto;
  final String empresa;

  Proveedor({
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.numeroContacto,
    required this.correoContacto,
    required this.empresa,
  });

  // Convertir a JSON para el POST y PUT (Ojo con las mayúsculas iniciales)
  Map<String, dynamic> toJson() => {
    "Nombre": nombre,
    "Apellido": apellido,
    "Cedula": cedula,
    "NumeroContacto": numeroContacto,
    "CorreoContacto": correoContacto,
    "Empresa": empresa,
  };

  // Recibir del backend en el GET
  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      nombre: json['Nombre'],
      apellido: json['Apellido'],
      cedula: json['Cedula'],
      numeroContacto: json['NumeroContacto'],
      correoContacto: json['CorreoContacto'],
      empresa: json['Empresa'],
    );
  }
}
