import 'package:parcial_mobil/articulos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcial_mobil/lista.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  String? token;
  List<Articulos> articulos = [];

  Future<void> fetchData(String token) async {
    //url donde estan los datos
    final response = await http.get(
        Uri.parse('http://192.168.105.1:8000/Favoritos/'),
        headers: {'Authorization': 'JWT $token'});
    if (response.statusCode == 200) {
      //obtenemos el cuerpo del json
      final data = json.decode(response.body);
      data.forEach((est) {
        final articulo = Articulos(
            id: est['id'],
            imagen: est['imagen'],
            articulo: est['nombre'],
            vendedor: est['vendedor'],
            estrella: (est['favorito'] == 1),
            calificaciones: est['calificacion']);
        articulos.add(articulo); //metemos los datos a la lista
      });
      print(articulos.length);
      setState(() {});
    } else {
      print('Algo salio mal...');
    }
  }

  Future<void> quitar(String token, int id) async {
    //url donde estan los datos
    final response = await http.post(
      Uri.parse('http://192.168.105.1:8000/Quitar'),
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'id': id,
      }),
    );
    if (response.statusCode == 200) {
      print('Exitoso');
    } else {
      print('Algo salio mal...');
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('token');
      if (token != null) {
        fetchData(token);
      }
    });
  }

  Future<void> CerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Favoritos"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Lista');
                },
                child: Text('Productos')),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Favoritos_grid');
                },
                icon: Icon(Icons.grid_view)),
            IconButton(
                onPressed: () {
                  CerrarSesion();
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: ListView(
          children: articulos.map((e) {
            return ContainerWidget(
              imagen: e.imagen,
              articulo: e.articulo,
              vendedor: e.vendedor,
              estrella: e.estrella,
              calificaciones: e.calificaciones,
              id: e.id,
              agregarFavorito: () {},
              quitarFavorito: () {
                SharedPreferences.getInstance().then((prefs) {
                  final token = prefs.getString('token');
                  if (token != null) {
                    quitar(token, e.id);
                  }
                });
              },
            );
          }).toList(),
        ));
  }
}
