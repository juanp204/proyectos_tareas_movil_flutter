import 'package:flutter/material.dart';
import 'api.dart';
import 'article.dart';
import 'item_articulo.dart';

class ListaArticulos extends StatelessWidget {
  final Api apiService;
  final List<Article> articles;

  const ListaArticulos({
    super.key,
    required this.apiService,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Artículos'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemArticulo(article: articles[index]);
        },
      ),
    );
  }
}
