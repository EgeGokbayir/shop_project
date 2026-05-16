import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  static const String bannerUrl = 'https://wantapi.com/assets/banner.png';

  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Product>> _productsFuture;
  String _searchText = '';
  String _selectedFilter = 'All';

  final List<String> _filters = <String>[
    'All',
    'iPhone',
    'Mac',
    'iPad',
    'Watch',
    'Audio',
    'Vision',
  ];

  @override
  void initState() {
    super.initState();
    _productsFuture = _repository.fetchProducts();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reloadProducts() {
    setState(() {
      _productsFuture = _repository.fetchProducts();
    });
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((Product product) {
      final String searchableText = '${product.name} ${product.tagline} ${product.category}'
          .toLowerCase();
      final bool matchesSearch = _searchText.isEmpty || searchableText.contains(_searchText);
      final bool matchesCategory = _selectedFilter == 'All' || product.category == _selectedFilter;

      return matchesSearch && matchesCategory;
    }).toList(growable: false);
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => const CartPage()),
    );
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _LoadErrorView(
                message: snapshot.error.toString(),
                onRetry: _reloadProducts,
              );
            }

            final List<Product> products = snapshot.data ?? <Product>[];
            final List<Product> filteredProducts = _filterProducts(products);

            return RefreshIndicator(
              onRefresh: () async => _reloadProducts(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _Header(onCartPressed: _openCart),
                          const SizedBox(height: 18),
                          _SearchBox(controller: _searchController),
                          const SizedBox(height: 14),
                          const _Banner(imageUrl: bannerUrl),
                          const SizedBox(height: 14),
                          _FilterBar(
                            filters: _filters,
                            selectedFilter: _selectedFilter,
                            onSelected: (String value) {
                              setState(() => _selectedFilter = value);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  if (filteredProducts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text('Aradığınız kritere uygun ürün bulunamadı.'),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Product product = filteredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () => _openDetail(product),
                            );
                          },
                          childCount: filteredProducts.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onCartPressed});

  final VoidCallback onCartPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Discover',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
        AnimatedBuilder(
          animation: cartController,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                IconButton(
                  onPressed: onCartPressed,
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          cartController.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search products',
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9B9EA4)),
        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF9B9EA4)),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 82,
        color: const Color(0xFFF1F2F4),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return const Center(
              child: Text(
                'Banner yüklenemedi',
                style: TextStyle(fontSize: 12, color: Color(0xFF777A80)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final String filter = filters[index];
          final bool selected = filter == selectedFilter;
          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            selectedColor: Colors.black,
            backgroundColor: const Color(0xFFF4F5F7),
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide.none,
            ),
            onSelected: (_) => onSelected(filter),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }
}

class _LoadErrorView extends StatelessWidget {
  const _LoadErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.wifi_off_outlined, size: 48, color: Color(0xFF9EA2AA)),
            const SizedBox(height: 14),
            const Text(
              'Ürünler API üzerinden yüklenemedi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF777A80)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
