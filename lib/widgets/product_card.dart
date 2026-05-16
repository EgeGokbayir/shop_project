import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'product_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFEDEFF2),
                  child: ProductNetworkImage(imageUrl: product.image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.tagline.isEmpty ? product.category : product.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF74777D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.priceText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1677FF),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: AnimatedBuilder(
                          animation: cartController,
                          builder: (BuildContext context, Widget? child) {
                            final bool inCart = cartController.contains(product.id);
                            return IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 18,
                              icon: Icon(
                                inCart
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 20,
                                color: inCart
                                    ? const Color(0xFF1677FF)
                                    : Colors.black54,
                              ),
                              onPressed: () {
                                cartController.add(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} sepete eklendi'),
                                    duration: const Duration(milliseconds: 900),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
