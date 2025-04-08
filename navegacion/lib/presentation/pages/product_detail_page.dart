import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recibimos el argumento enviado desde la lista
    final String productName =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Detalle del Producto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Producto seleccionado:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(
              productName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // volver a la lista
              },
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
