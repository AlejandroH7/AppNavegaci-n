import 'package:flutter/material.dart';
import 'package:navegacion/presentation/pages/product_list_page.dart'; // Ajusta el nombre si tu proyecto se llama diferente

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalle de Producto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductListPage(), // La pantalla principal es la lista de productos
    );
  }
}
