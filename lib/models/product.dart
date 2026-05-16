class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  String get category {
    final String lowerName = name.toLowerCase();

    if (lowerName.contains('iphone')) return 'iPhone';
    if (lowerName.contains('macbook') || lowerName == 'imac') return 'Mac';
    if (lowerName.contains('ipad')) return 'iPad';
    if (lowerName.contains('watch')) return 'Watch';
    if (lowerName.contains('airpods') || lowerName.contains('homepod')) {
      return 'Audio';
    }
    if (lowerName.contains('vision')) return 'Vision';

    return 'Product';
  }

  double get priceValue {
    final String normalized = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  String get priceText {
    if (price.isNotEmpty) return price;
    return '\$${priceValue.toStringAsFixed(0)}';
  }

  List<String> get specLabels {
    return specs.entries
        .map((MapEntry<String, String> entry) => '${entry.key.toUpperCase()}\n${entry.value}')
        .toList(growable: false);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final Map<String, String> parsedSpecs = <String, String>{};
    final dynamic specsJson = json['specs'];

    if (specsJson is Map) {
      specsJson.forEach((dynamic key, dynamic value) {
        parsedSpecs[key.toString()] = value.toString();
      });
    }

    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'USD',
      image: json['image']?.toString() ?? '',
      specs: parsedSpecs,
    );
  }
}
