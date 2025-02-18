import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'usuario.dart'; // Importa la clase Usuario desde tu otro archivo
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  Future<List<Usuario>> _fetchUsuarios() async {
    String sUrl = "https://api.npoint.io/bffbb3b6b3ad5e711dd2";
    final response = await http.get(Uri.parse(sUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['items'];
      return data
          .map((userData) => Usuario(
                nombre: userData['nombre'],
                carrera: userData['carrera'],
                promedio: userData['promedio'].toDouble(),
              ))
          .toList();
    } else {
      throw Exception('Failed to load usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Usuarios"),
        ),
        body: Center(
          child: FutureBuilder<List<Usuario>>(
            future: _fetchUsuarios(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Usuario>? usuarios = snapshot.data;
                return ListView.builder(
                  itemCount: usuarios!.length,
                  itemBuilder: (context, index) {
                    Usuario usuario = usuarios[index];
                    return usuario; // Utiliza el widget Usuario directamente
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
