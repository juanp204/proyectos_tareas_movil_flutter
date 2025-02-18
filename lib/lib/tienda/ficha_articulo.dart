import 'package:flutter/material.dart';
import 'article.dart';
import 'valoracion.dart';

class FichaArticulo extends StatelessWidget {
  const FichaArticulo({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    double precioConDescuento = double.parse(article.precio) *
        (1 - double.parse(article.descuento) / 100);

    int valoracion = int.parse(article.valoracion);
    int valoracionParteEntera = valoracion ~/ 10;
    int valoracionParteDecimal = valoracion % 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.articulo),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.network(
                    article.urlimagen,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descripción:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(article.descripcion),
                const SizedBox(height: 16),
                Text(
                  'Precio original: ${article.precio}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (article.descuento != "0")
                  Container(
                    color: Colors.green,
                    child: Text(
                      'Descuento: ${article.descuento}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (article.descuento != "0")
                  Text(
                    'Precio con descuento: $precioConDescuento',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const Text('Valoración:'),
                Row(
                  children: [
                    Text(
                      '$valoracionParteEntera.',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '$valoracionParteDecimal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Valoracion(calificacion: valoracion),
                  ],
                ),
                Text('Calificaciones: ${article.calificaciones}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
