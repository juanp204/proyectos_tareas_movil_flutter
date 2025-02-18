import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:last_quiz/tienda/api.dart';
import 'package:last_quiz/tienda/menu_principal.dart';
import 'package:last_quiz/tienda/lista_articulos.dart';
import 'package:last_quiz/tienda/article.dart';
import 'package:last_quiz/tienda/lista_ofertas.dart';

class HomePagearticles extends StatelessWidget {
  static String domain = "192.168.195.1";
  final Api apiService = Api(apiUrl: 'http://$domain:3000/data');
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artículos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icono para el botón de cierre de sesión
            onPressed: () {
              storage.delete(key: "token");
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
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
        onHuellaTap: () => Navigator.pushNamed(context, '/huella'),
      ),
      body: const Center(
        child: Text('Bienvenido'),
      ),
    );
  }
}
