import 'package:flutter/material.dart';
import 'item_widget.dart'; // Asegúrate de importar item_widget.dart correctamente

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGrid = false; // Controla el modo de visualización

  final List<String> items = ['Ítem 1', 'Ítem 2', 'Ítem 3']; // Lista de ejemplo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_on), // Cambia el ícono según el estado
            onPressed: () {
              setState(() {
                isGrid = !isGrid; // Cambia entre modo lista y modo cuadrícula
              });
            },
          ),
        ],
      ),
      body: isGrid ? buildGridView() : buildListView(),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemWidget(
          title: items[index],
          description: 'Descripción de ${items[index]}',
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Muestra 2 elementos por fila
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemWidget(
          title: items[index],
          description: 'Descripción de ${items[index]}',
        );
      },
    );
  }
}