import 'package:app_quanlyxaydung/models/product.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/product_detail_page.dart';
import 'package:app_quanlyxaydung/services/product_service.dart';
import 'package:app_quanlyxaydung/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.session,
    required this.onLogout,
    this.filterCategory,
    this.categoryName,
  });

  final UserSession session;
  final VoidCallback onLogout;
  final String? filterCategory;
  final String? categoryName;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _productService = ProductService();
  final _searchCtrl = TextEditingController();
  String? _selectedCategory;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.filterCategory;
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      if (_selectedCategory != null) {
        _products = _productService.getByCategory(_selectedCategory!);
      } else if (_searchCtrl.text.isNotEmpty) {
        _products = _productService.search(_searchCtrl.text);
      } else {
        _products = _productService.getAll();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(
              widget.categoryName ?? 'Sản phẩm',
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => _loadProducts(),
                    decoration: InputDecoration(
                      hintText: 'Tìm sản phẩm…',
                      hintStyle: GoogleFonts.inter(
                          color: Colors.grey[400], fontSize: 13),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategoryFilter(context),
          ),
        ],
        body: _products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.4)),
                    const SizedBox(height: 12),
                    Text(
                      'Không tìm thấy sản phẩm',
                      style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _products.length,
                itemBuilder: (ctx, i) => ProductCard(
                  product: _products[i],
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(
                        product: _products[i],
                        session: widget.session,
                        onLogout: widget.onLogout,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ProductService.categories;

    return Container(
      color: theme.colorScheme.surface,
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length + 1,
        itemBuilder: (ctx, i) {
          final isAll = i == 0;
          final isSelected = isAll
              ? _selectedCategory == null
              : _selectedCategory == categories[i - 1].id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = isAll ? null : categories[i - 1].id;
              });
              _loadProducts();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                isAll ? 'Tất cả' : categories[i - 1].name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
