import 'package:flutter/material.dart';

import '../models/product.dart';

class CartEntry {
  CartEntry({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.priceValue * quantity;
}

class CartController extends ChangeNotifier {
  final Map<int, CartEntry> _entries = <int, CartEntry>{};

  List<CartEntry> get items => _entries.values.toList(growable: false);

  int get totalItems {
    int total = 0;
    for (final CartEntry entry in _entries.values) {
      total += entry.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (final CartEntry entry in _entries.values) {
      total += entry.subtotal;
    }
    return total;
  }

  bool contains(int productId) => _entries.containsKey(productId);

  void add(Product product) {
    final CartEntry? existingEntry = _entries[product.id];

    if (existingEntry == null) {
      _entries[product.id] = CartEntry(product: product);
    } else {
      existingEntry.quantity += 1;
    }

    notifyListeners();
  }

  void decrease(int productId) {
    final CartEntry? existingEntry = _entries[productId];
    if (existingEntry == null) return;

    if (existingEntry.quantity <= 1) {
      _entries.remove(productId);
    } else {
      existingEntry.quantity -= 1;
    }

    notifyListeners();
  }

  void remove(int productId) {
    _entries.remove(productId);
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}

final CartController cartController = CartController();
