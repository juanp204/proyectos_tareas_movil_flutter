import 'package:flutter/material.dart';

class OptionSelectorRadio extends StatefulWidget {
  const OptionSelectorRadio({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OptionSelectorRadioState createState() => _OptionSelectorRadioState();
}

class _OptionSelectorRadioState extends State<OptionSelectorRadio> {
  String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Amarillo'),
            value: 'Amarillo',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() => _selectedOption = value!);
            },
          ),
          RadioListTile<String>(
            title: const Text('Azul'),
            value: 'Azul',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() => _selectedOption = value!);
            },
          ),
          RadioListTile<String>(
            title: const Text('Rojo'),
            value: 'Rojo',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() => _selectedOption = value!);
            },
          ),
          RadioListTile<String>(
            title: const Text('Verde'),
            value: 'Verde',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() => _selectedOption = value!);
            },
          ),
          RadioListTile<String>(
            title: const Text('Naranja'),
            value: 'Naranja',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() => _selectedOption = value!);
            },
          ),
          ElevatedButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.pop(context, _selectedOption),
          ),
        ],
      ),
    );
  }
}