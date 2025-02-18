import 'package:flutter/material.dart';

class Valoracion extends StatelessWidget {
  final int calificacion;

  const Valoracion({Key? key, required this.calificacion});

  @override
  Widget build(BuildContext context) {
    final double rating = calificacion / 20.0;

    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ),
    );
  }
}
