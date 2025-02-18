import 'package:flutter/material.dart';
import 'api.dart';
import 'article.dart';
import 'item_articulo.dart';

class ListaOfertas extends StatelessWidget {
  final Api apiService;
  final List<Article> articles;

  const ListaOfertas({
    super.key,
    required this.apiService,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    final List<Article> ofertas =
        articles.where((article) => article.descuento != "0").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Ofertas'),
      ),
      body: ListView.builder(
        itemCount: ofertas.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemArticulo(article: ofertas[index]);
        },
      ),
    );
  }
}
