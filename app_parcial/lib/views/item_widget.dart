import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String title;
  final String description;

  const ItemWidget({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.star), // Icono de ejemplo
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        // Acción al tocar el ítem
      },
    );
  }
}