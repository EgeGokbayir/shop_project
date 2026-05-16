import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/product_network_image.dart';
import '../widgets/spec_chip.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              cartController.add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} sepete eklendi'),
                  duration: const Duration(milliseconds: 900),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add to Cart  •  ${product.priceText}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: <Widget>[
            _BackButton(),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 315,
                color: const Color(0xFFF1F2F4),
                child: ProductNetworkImage(imageUrl: product.image),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.tagline.isEmpty ? product.category : product.tagline,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF686B70),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 12,
                height: 1.45,
                color: Color(0xFF55585D),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.specLabels
                  .map((String spec) => SpecChip(label: spec))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(Icons.arrow_back_ios_new, size: 15),
        label: const Text(
          'Back',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
