import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = product['name'] ?? 'Sin nombre';
    final data = product['data'] as Map<String, dynamic>?; // puede ser null

    return Scaffold(
      appBar: AppBar(title: Text('Detalle del Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(name, style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text(
              'Detalles:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            data != null
                ? Expanded(
                  child: ListView(
                    children:
                        data.entries.map((entry) {
                          return ListTile(
                            title: Text('${entry.key}:'),
                            subtitle: Text('${entry.value}'),
                          );
                        }).toList(),
                  ),
                )
                : Text('No hay detalles disponibles.'),
          ],
        ),
      ),
    );
  }
}
