import 'package:flutter/material.dart';
import 'option_selector_radio.dart';
import 'option_selector_touch.dart';

class FirstView extends StatefulWidget {
  const FirstView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstViewState createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  String selectedOption = '';

  void _showModalBottomSheetRadio(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return OptionSelectorRadio();
      },
    );
    if (result != null) {
      setState(() => selectedOption = result);
    }
  }

  void _showModalBottomSheetTouch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return OptionSelectorTouch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratorio 9: showModalBottomSheet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showModalBottomSheetRadio(context),
              child: const Text('Mostrar opción por selección de radio button'),
            ),
            const SizedBox(height: 20),
            if (selectedOption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Opción seleccionada: $selectedOption'),
              ),
            ElevatedButton(
              onPressed: () => _showModalBottomSheetTouch(context),
              child: const Text('Mostrar opción por touch'),
            ),
          ],
        ),
      ),
    );
  }
}