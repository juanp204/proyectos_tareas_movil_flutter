import 'package:flutter/material.dart';
import 'item_widget.dart'; // Asegúrate de importar item_widget.dart correctamente

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isGrid = false; // Controla el modo de visualización

  final List<String> favoriteItems = ['Favorito 1', 'Favorito 2']; // Lista de ejemplo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
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
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        return ItemWidget(
          title: favoriteItems[index],
          description: 'Descripción de ${favoriteItems[index]}',
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Muestra 2 elementos por fila
        childAspectRatio: 3 / 2, // Ajusta la proporción de los elementos si es necesario
      ),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        return ItemWidget(
          title: favoriteItems[index],
          description: 'Descripción de ${favoriteItems[index]}',
        );
      },
    );
  }
}