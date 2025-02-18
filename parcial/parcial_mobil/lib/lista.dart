import 'package:flutter/material.dart';

class ContainerWidget extends StatefulWidget {
  final int id;
  final String imagen;
  final String articulo;
  final String vendedor;
  final int calificaciones;
  final bool estrella;
  final Function() agregarFavorito;
  final Function() quitarFavorito;

  const ContainerWidget(
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
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: NetworkImage(widget.imagen),
                    width: 100,
                    height: 100,
                  )
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Articulo: ${widget.articulo}'),
                  Text(widget.id.toString()),
                  Text('Vendedor: ${widget.vendedor}'),
                  Row(
                    children: [
                      Text(
                          'Calificaciones: ${widget.calificaciones.toString()}'),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                          if (_isFavorited) {
                            widget.agregarFavorito();
                          } else {
                            widget.quitarFavorito();
                          }
                        },
                        icon: Icon(
                          _isFavorited ? Icons.star : Icons.star_border,
                          color: _isFavorited ? Colors.yellow : null,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
