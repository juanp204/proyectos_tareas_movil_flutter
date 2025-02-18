import 'package:flutter/material.dart';
import 'package:quiz_mobil/main.dart';

class Usuario extends StatelessWidget {
  final String nombre;
  final String carrera;
  final String imagen;
  final String universidad;

  const Usuario(
      {super.key,
      required this.nombre,
      required this.carrera,
      required this.universidad,
      required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 150),
        Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
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
            )),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  nombre,
                  style: const TextStyle(fontSize: 17),
                )
              ]),
              Row(children: [Text(carrera)]),
              Row(children: [
                Text(universidad, style: const TextStyle(fontSize: 17))
              ]),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, '/vista2');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Vista2(
                            imagen: imagen,
                          ),
                        ),
                      );
                    },
                    child: const Text('Perfil'),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
