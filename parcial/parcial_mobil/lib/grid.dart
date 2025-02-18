import 'package:flutter/material.dart';

class Container2Widget extends StatefulWidget {
  final int id;
  final String imagen;
  final String articulo;
  final String vendedor;
  final int calificaciones;
  final bool estrella;
  final Function() agregarFavorito;
  final Function() quitarFavorito;

  const Container2Widget(
      {Key? key,
      required this.id,
      required this.imagen,
      required this.articulo,
      required this.vendedor,
      required this.calificaciones,
      required this.estrella,
      required this.agregarFavorito,
      required this.quitarFavorito})
      : super(key: key);

  @override
  _Container2WidgetState createState() => _Container2WidgetState();
}

class _Container2WidgetState extends State<Container2Widget> {
  late bool _isFavorited;

  @override
  void initState() {
    _isFavorited = widget.estrella;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: NetworkImage(widget.imagen),
            width: 100,
            height: 100,
          ),
          Text('Articulo: ${widget.articulo}'),
          Text('Vendedor: ${widget.vendedor}'),
          Row(
            children: [
              Text('Calificaciones: ${widget.calificaciones.toString()}'),
              SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                  if (_isFavorited) {
                    widget.agregarFavorito();
                  }
                  widget.quitarFavorito();
                },
                icon: Icon(
                  _isFavorited ? Icons.star : Icons.star_border,
                  color: _isFavorited ? Colors.yellow : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
