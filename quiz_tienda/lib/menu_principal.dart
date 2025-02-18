import 'package:flutter/material.dart';

class MenuPrincipal extends StatelessWidget {
  final VoidCallback onArticulosTap;
  final VoidCallback onOfertasTap;

  const MenuPrincipal({
    super.key,
    required this.onArticulosTap,
    required this.onOfertasTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          InkWell(
            onTap: onArticulosTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: const Text(
                'Lista de Artículos',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onOfertasTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: const Text(
                'Lista de Ofertas',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
