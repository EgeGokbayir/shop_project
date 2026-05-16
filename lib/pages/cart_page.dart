import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.info_outline, size: 16, color: Color(0xFF777A80)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the printing.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF777A80)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: cartController,
                builder: (BuildContext context, Widget? child) {
                  return ElevatedButton(
                    onPressed: cartController.items.isEmpty
                        ? null
                        : () {
                            _showCheckoutDialog(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.black,
                      disabledForegroundColor: Colors.white70,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cartController.items.isEmpty
                          ? 'Checkout'
                          : 'Checkout  •  \$${cartController.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: cartController,
          builder: (BuildContext context, Widget? child) {
            final List<CartEntry> items = cartController.items;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 15),
                        label: const Text(
                          'Cart',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (items.isNotEmpty)
                        TextButton(
                          onPressed: cartController.clear,
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const _EmptyCartView()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CartItemTile(entry: items[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sipariş Simülasyonu'),
          content: Text(
            'Toplam ${cartController.totalItems} ürün için ödeme simülasyonu tamamlandı.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                cartController.clear();
                Navigator.pop(dialogContext);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_cart_outlined,
              size: 58,
              color: Color(0xFFB8BBC1),
            ),
            SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF777A80),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Add items to start shopping',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFA3A6AD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
