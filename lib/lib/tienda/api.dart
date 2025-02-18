import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final String apiUrl;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late final Future<String?> token;

  Api({required this.apiUrl}) {
    token = secureStorage.read(key: "token");
  }

  Future<List<Article>> getArticles() async {
    final String? fetchedToken = await token;
    if (fetchedToken == null || fetchedToken.isEmpty) {
      throw Exception('Token is null or empty');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization':
            fetchedToken, // Agregar token de autorización en el encabezado
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articulos'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
