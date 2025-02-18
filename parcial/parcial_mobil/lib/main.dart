import 'dart:convert';
import 'package:parcial_mobil/apis/api.dart';
import 'package:parcial_mobil/apis/api_favoritos.dart';
import 'package:parcial_mobil/apis/api_favoritos_grid.dart';
import 'package:parcial_mobil/apis/api_grid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/Lista': (context) => Usuarios(),
        '/Favoritos': (context) => Favoritos(),
        '/Lista_grid': (context) => UsuariosGrid(),
        '/Favoritos_grid': (context) => FavoritosGrid()
      },
    );
  }
}

//login
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nombre = TextEditingController();
  final contrasena = TextEditingController();

  Future<String?> fetchAuthToken(String username, String password) async {
    final Map<String, dynamic> respuesta = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.105.1:8000/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(respuesta),
      );
      final data = json.decode(response.body);
      final token = data['access'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      return token;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> _login() async {
    final username = nombre.text;
    final password = contrasena.text;

    try {
      final token = await fetchAuthToken(username, password);
      if (token != null) {
        Navigator.pushNamed(context, '/Lista');
      }
    } catch (e) {
      // Si hay un error durante el inicio de sesión, navegar a la página '/Lista'
      //Navigator.pushNamed(context, '/Lista');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(labelText: 'nombre'),
                ),
                TextField(
                  controller: contrasena,
                  decoration: InputDecoration(labelText: 'contrasena'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ));
  }
}
