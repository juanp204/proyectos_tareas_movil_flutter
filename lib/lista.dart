import 'package:flutter/material.dart';

class container extends StatelessWidget{
  final int id;
  final String imagen;
  final String articulo;
  final String vendedor;
  final int calificaciones;
  final bool estrella;
  final Function() agregarFavorito;
  const container({
      Key? key,
      required this.id,
      required this.imagen,
      required this.articulo,
      required this.vendedor,
      required this.calificaciones,
      required this.estrella,
      required this.agregarFavorito
    }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          //columna de la izquierda de la imagen
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: NetworkImage(imagen),width: 100, height: 100,)
            ],
          ),
          SizedBox(width: 10,),
          //columna de la derecha de los datos
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Articulo: ${articulo}'), Text(id.toString()),Text('Vendedor: ${vendedor}'), 
              Row(
                children: [
                  Text('Calificaciones:${calificaciones.toString()}'),
                  SizedBox(width: 20,),
                  if(estrella)
                    IconButton(
                      onPressed: agregarFavorito, 
                      icon: Icon(Icons.star,color: Colors.yellow,)
                    ),
                  if(!estrella)
                    IconButton(
                      onPressed: agregarFavorito, 
                      icon: Icon(Icons.star_border)
                    ),
                ],
              )
            ],
          )
        ],
      ),
      SizedBox(height: 30,)
    ]),
    );
  }
}