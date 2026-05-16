import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import 'product_network_image.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.entry,
  });

  final CartEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              color: const Color(0xFFF0F1F4),
              child: ProductNetworkImage(imageUrl: entry.product.image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.product.tagline.isEmpty
                      ? entry.product.category
                      : entry.product.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777A80),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${entry.subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1677FF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              _RoundIconButton(
                icon: Icons.remove,
                onPressed: () => cartController.decrease(entry.product.id),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  entry.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _RoundIconButton(
                icon: Icons.add,
                onPressed: () => cartController.add(entry.product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: const BorderSide(color: Color(0xFFE1E3E6)),
        ),
        child: Icon(icon, size: 14, color: Colors.black87),
      ),
    );
  }
}
