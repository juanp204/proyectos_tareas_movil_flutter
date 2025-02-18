import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'usuario.dart';
import 'dart:convert';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => const Vista1()},
    );
  }
}

class Vista1 extends StatelessWidget {
  const Vista1({Key? key}) : super(key: key);

  Future<List<Usuario>> _fetchUsuarios() async {
    String sUrl = "https://api.npoint.io/5cb393746e518d1d8880";
    final response = await http.get(Uri.parse(sUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['elementos'];
      return data
          .map((userData) => Usuario(
              nombre: userData['nombreCompleto'],
              carrera: userData['profesion'],
              universidad: userData['estudios'][0]['universidad'],
              imagen: userData['urlImagen']))
          .toList();
    } else {
      print("error lista");
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
                print("waiting");
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print("error");
                return Text('Error: ${snapshot.error}');
              } else {
                List<Usuario>? usuarios = snapshot.data;
                print(usuarios!.length);
                return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    Usuario usuario = usuarios[index];
                    return usuario;
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

class Vista2 extends StatelessWidget {
  final String imagen;

  const Vista2({super.key, required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista 2')),
      body: Center(
        child: ListView(
          children: [
            Image.network(
              imagen,
              width: 120,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.amber[600],
                  width: 48.0,
                  height: 48.0,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Regresar a Vista 1'),
            )
          ],
        ),
      ),
    );
  }
}
