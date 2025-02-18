import 'package:flutter/material.dart';

class ThirdView extends StatelessWidget {
  final String buttonText;

  ThirdView(this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opción seleccionada'),
      ),
      body: Center(
        child: Text('Botón presionado: $buttonText'),
      ),
    );
  }
}