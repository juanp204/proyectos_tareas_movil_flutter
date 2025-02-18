class Article {
  final String precio;
  final String articulo;
  final String descuento;
  final String urlimagen;
  final String valoracion;
  final String descripcion;
  final String calificaciones;

  Article({
    required this.precio,
    required this.articulo,
    required this.descuento,
    required this.urlimagen,
    required this.valoracion,
    required this.descripcion,
    required this.calificaciones,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      precio: json['precio'],
      articulo: json['articulo'],
      descuento: json['descuento'],
      urlimagen: json['urlimagen'],
      valoracion: json['valoracion'],
      descripcion: json['descripcion'],
      calificaciones: json['calificaciones'],
    );
  }
}
