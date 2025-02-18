import 'package:flutter/material.dart';
import 'third_view.dart';

class OptionSelectorTouch extends StatelessWidget {
  const OptionSelectorTouch({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.lens, color: Colors.yellow),
          title: const Text('Amarillo'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdView('Amarillo')),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lens, color: Colors.blue),
          title: const Text('Azul'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdView('Azul')),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lens, color: Colors.red),
          title: const Text('Rojo'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdView('Rojo')),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lens, color: Colors.green),
          title: const Text('Verde'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdView('Verde')),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lens, color: Colors.orange),
          title: const Text('Naranja'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdView('Naranja')),
          ),
        ),
      ],
    );
  }
}