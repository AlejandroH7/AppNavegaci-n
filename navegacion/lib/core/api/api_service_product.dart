import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceProduct {
  static const String baseUrl = 'https://api.restful-api.dev/objects';

  // Método GET
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  // Método POST
  Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear producto');
    }
  }

  // Método PUT
  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    final url = '$baseUrl/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }

  // Método DELETE
  Future<void> deleteProduct(String id) async {
    final url = '$baseUrl/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }
}
