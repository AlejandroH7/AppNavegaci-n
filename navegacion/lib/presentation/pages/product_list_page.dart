import 'package:flutter/material.dart';
import 'package:navegacion/core/api/api_service_product.dart'; // Asegúrate de poner el import correcto
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiServiceProduct apiService = ApiServiceProduct();
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = apiService.getProducts();
  }

  void _refreshProducts() {
    setState(() {
      _futureProducts = apiService.getProducts();
    });
  }

  void _showEditProductForm(Map<String, dynamic> product) {
    final TextEditingController nameController = TextEditingController(
      text: product['name'],
    );
    final TextEditingController detailKeyController = TextEditingController();
    final TextEditingController detailValueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Editar Producto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre del Producto'),
                ),
                TextField(
                  controller: detailKeyController,
                  decoration: InputDecoration(labelText: 'Detalle (ej: color)'),
                ),
                TextField(
                  controller: detailValueController,
                  decoration: InputDecoration(
                    labelText: 'Valor del Detalle (ej: Blanco)',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text.trim();
                    final String detailKey = detailKeyController.text.trim();
                    final String detailValue =
                        detailValueController.text.trim();

                    if (name.isNotEmpty) {
                      final updatedProduct = {
                        "name": name,
                        "data":
                            detailKey.isNotEmpty && detailValue.isNotEmpty
                                ? {detailKey: detailValue}
                                : {},
                      };

                      try {
                        await apiService.updateProduct(
                          product['id'],
                          updatedProduct,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Producto actualizado exitosamente'),
                          ),
                        );
                        _refreshProducts();
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al actualizar producto'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Actualizar'),
                ),
              ],
            ),
          ),
    );
  }

  void _deleteProduct(String id) async {
    try {
      await apiService.deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto eliminado exitosamente')),
      );
      _refreshProducts();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar producto')));
    }
  }

  // 🆕 Mostrar formulario para agregar producto
  void _showAddProductForm() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController detailKeyController = TextEditingController();
    final TextEditingController detailValueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Agregar Nuevo Producto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre del Producto'),
                ),
                TextField(
                  controller: detailKeyController,
                  decoration: InputDecoration(labelText: 'Detalle (ej: color)'),
                ),
                TextField(
                  controller: detailValueController,
                  decoration: InputDecoration(
                    labelText: 'Valor del Detalle (ej: Blanco)',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text.trim();
                    final String detailKey = detailKeyController.text.trim();
                    final String detailValue =
                        detailValueController.text.trim();

                    if (name.isNotEmpty &&
                        detailKey.isNotEmpty &&
                        detailValue.isNotEmpty) {
                      final newProduct = {
                        "name": name,
                        "data": {detailKey: detailValue},
                      };

                      try {
                        await apiService.createProduct(newProduct);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Producto creado exitosamente'),
                          ),
                        );
                        _refreshProducts(); // Refrescar lista
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al crear producto')),
                        );
                      }
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Productos')),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos disponibles'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final name = product['name'] ?? 'Producto sin nombre';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditProductForm(product);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteProduct(product['id']);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _showAddProductForm, // 🆕 Llamamos el método para abrir formulario
        child: Icon(Icons.add),
      ),
    );
  }
}
