import 'dart:convert';
import 'dart:io';

import '../models/product.dart';

class ProductRepository {
  static const String productsUrl = 'https://wantapi.com/products.php';

  Future<List<Product>> fetchProducts() async {
    final HttpClient client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final Uri uri = Uri.parse(productsUrl);
      final HttpClientRequest request = await client.getUrl(uri);
      final HttpClientResponse response = await request.close().timeout(
            const Duration(seconds: 20),
          );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('API isteği başarısız oldu. HTTP ${response.statusCode}');
      }

      final String responseBody = await response.transform(utf8.decoder).join();
      final dynamic decodedJson = jsonDecode(responseBody);

      final List<dynamic> productList = _extractProductList(decodedJson);

      return productList
          .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } finally {
      client.close(force: true);
    }
  }

  List<dynamic> _extractProductList(dynamic decodedJson) {
    if (decodedJson is Map<String, dynamic>) {
      final dynamic data = decodedJson['data'];
      if (data is List<dynamic>) return data;
    }

    if (decodedJson is List<dynamic>) return decodedJson;

    throw Exception('API cevabı beklenen ürün listesi formatında değil.');
  }
}
