import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  Future<String?> fetchAuthToken(String username, String password) async {
    final Map<String, dynamic> respuesta = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.96:8000/auth'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Usuario',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  // Aquí iría la lógica para iniciar sesión
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
