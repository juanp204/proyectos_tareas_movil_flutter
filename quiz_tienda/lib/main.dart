import 'package:flutter/material.dart';
import 'api.dart';
import 'article.dart';
import 'menu_principal.dart';
import 'lista_articulos.dart';
import 'lista_ofertas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Api api = Api(apiUrl: 'https://api.npoint.io/9d122573b46e2ac7a185');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista_Articulos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(apiService: api),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Api apiService;

  MyHomePage({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artículos'),
      ),
      drawer: MenuPrincipal(
        onArticulosTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder(
                future: apiService.getArticles(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Article> articles = snapshot.data;
                    return ListaArticulos(
                      apiService: apiService,
                      articles: articles,
                    );
                  }
                },
              ),
            ),
          );
        },
        onOfertasTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder(
                future: apiService.getArticles(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Article> articles = snapshot.data;
                    final List<Article> ofertas = articles
                        .where((article) => article.descuento.isNotEmpty)
                        .toList();
                    return ListaOfertas(
                      apiService: apiService,
                      articles: ofertas,
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
      body: const Center(
        child: Text('Bienvenido'),
      ),
    );
  }
}
