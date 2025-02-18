import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class Api {
  final String apiUrl;

  Api({required this.apiUrl});

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articulos'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
