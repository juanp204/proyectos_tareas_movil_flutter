class Articulos {
  final int id;
  final String imagen;
  final String articulo;
  final String vendedor;
  final int calificaciones;
  final bool estrella;

  Articulos(
      {required this.id,
      required this.imagen,
      required this.articulo,
      required this.vendedor,
      required this.calificaciones,
      required this.estrella});

  Map<String, dynamic> toMap() {
    return {'articulo': articulo};
  }
}
