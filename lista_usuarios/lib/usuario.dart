import 'package:flutter/material.dart';

class Usuario extends StatelessWidget {
  final String nombre;
  final String carrera;
  final double promedio;

  const Usuario(
      {super.key,
      required this.nombre,
      required this.carrera,
      required this.promedio});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 100),
        Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                width: 100,
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
        Column(
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
              Text(promedio.toString(), style: const TextStyle(fontSize: 17))
            ])
          ],
        )
      ],
    );
  }
}
