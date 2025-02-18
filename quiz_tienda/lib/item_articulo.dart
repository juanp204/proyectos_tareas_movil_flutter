import 'package:flutter/material.dart';
import 'article.dart';
import 'ficha_articulo.dart';
import 'valoracion.dart';

class ItemArticulo extends StatelessWidget {
  const ItemArticulo({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FichaArticulo(article: article),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(
              article.urlimagen,
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.articulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Precio: ${article.precio}'),
                  if (article.descuento.isNotEmpty &&
                      int.parse(article.descuento) > 0)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        'Descuento: ${article.descuento}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  Valoracion(calificacion: int.parse(article.valoracion)),
                  Text('Calificaciones: ${article.calificaciones}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
