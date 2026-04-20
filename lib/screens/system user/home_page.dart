import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/system_user/product_detail_page.dart';
import 'package:app_quanlyxaydung/screens/system_user/product_list_page.dart';
import 'package:app_quanlyxaydung/services/product_service.dart';
import 'package:app_quanlyxaydung/widgets/product_card.dart';
import 'package:app_quanlyxaydung/screens/system_user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.session, required this.onLogout});

  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  final _productService = ProductService();
  var _searchResults = <dynamic>[];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    if (q.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _searchResults = _productService.search(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar(context)),

            if (_isSearching) ...[
              // Phần tìm kiếm
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Text(
                    '${_searchResults.length} kết quả tìm kiếm',
                    style: GoogleFonts.inter(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => ProductCard(
                      product: _searchResults[i],
                      onTap: () => _openDetail(ctx, _searchResults[i]),
                    ),
                    childCount: _searchResults.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(child: _buildHeroBanner(context)),
              SliverToBoxAdapter(child: _buildFeatureBanners(context)),
              SliverToBoxAdapter(child: _buildQuickCategories(context)),
              // Hàng mới về
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hàng Mới Về',
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductListPage(
                              session: widget.session,
                              onLogout: widget.onLogout,
                            ),
                          ),
                        ),
                        child: const Text('Xem tất cả'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final products = _productService.getFeatured();
                    return ProductCard(
                      product: products[i],
                      onTap: () => _openDetail(ctx, products[i]),
                    );
                  }, childCount: _productService.getFeatured().length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // Các hàm _buildHeader, _buildSearchBar, _buildFeatureBanners, _buildQuickCategories, _openDetail... 
  // (giữ nguyên như file cũ của bạn, chỉ thay _buildHeroBanner)

  Widget _buildHeroBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 190),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.secondary,
              const Color(0xFFBF360C),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ... (giữ nguyên phần decorative circles và icon eco)
            Positioned(
              right: -30,
              top: -30,
              child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05))),
            ),
            Positioned(
              right: 20,
              bottom: -20,
              child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06))),
            ),
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Icon(Icons.eco, size: 110, color: Colors.white.withValues(alpha: 0.1)),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.8),
                    ),
                    child: const Text(
                      '🌾 Farm Fresh Organic Harvest',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fresh Every Day',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sourcing organic farm-to-table\ngroceries for your family.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.55),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 36,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B5E20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListPage(session: widget.session, onLogout: widget.onLogout),
                        ),
                      ),
                      child: const Text('Mua ngay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Các hàm còn lại (_buildFeatureBanners, _buildQuickCategories, _openDetail, _FeatureBannerCard) giữ nguyên như file cũ của bạn
}