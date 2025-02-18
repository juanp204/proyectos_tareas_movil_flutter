import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final String productName;
  final String productDescription;

  ProductWidget({required this.productName, required this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text(productDescription),
      ),
    );
  }
}