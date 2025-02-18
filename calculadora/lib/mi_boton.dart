import 'package:flutter/material.dart';

class MiBoton extends StatelessWidget {
  final String texto;
  final Function()? accionBoton; // Cambiado el tipo de accionBoton a Function()

  MiBoton({
    Key? key, // Agregado key como parámetro
    required this.texto, // Cambiado var a final y agregado required
    required this.accionBoton, // Cambiado var a final y agregado required
  }) : super(key: key); // Llamada a super con key

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: accionBoton, // Llamada a la función accionBoton directamente
        child: Text(texto),
      ),
    );
  }
}
