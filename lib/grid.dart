import 'package:flutter/material.dart';

class container2 extends StatelessWidget{
  final int id;
  final String imagen;
  final String articulo;
  final String vendedor;
  final int calificaciones;
  final bool estrella;
  final Function() agregarFavorito;
  const container2({
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
      child:
          //articulo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Image(image: NetworkImage(imagen),width: 100, height: 100,),Text('Articulo: ${articulo}'), Text('Vendedor: ${vendedor}'), 
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
      );
  }
}