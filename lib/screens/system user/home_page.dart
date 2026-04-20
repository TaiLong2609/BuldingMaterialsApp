import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/screens/system user/product_detail_page.dart';
import 'package:app_bachhoa/screens/system user/product_list_page.dart';
import 'package:app_bachhoa/services/product_service.dart';
import 'package:app_bachhoa/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.session,
    required this.onLogout,
  });

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
            // ── App Bar / Header ──
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            // ── Search bar ──
            SliverToBoxAdapter(
              child: _buildSearchBar(context),
            ),
            if (_isSearching) ...[
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
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ] else ...[
              // ── Hero Banner ──────────────────────────────────
              SliverToBoxAdapter(child: _buildHeroBanner(context)),
              // ── Feature Banners (Eco + Express) ─────────────
              SliverToBoxAdapter(child: _buildFeatureBanners(context)),
              // ── Quick Categories ─────────────────────────────
              SliverToBoxAdapter(child: _buildQuickCategories(context)),
              // ── New Arrivals Section header ───────────────────
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
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final products = _productService.getFeatured();
                      return ProductCard(
                        product: products[i],
                        onTap: () => _openDetail(ctx, products[i]),
                      );
                    },
                    childCount: _productService.getFeatured().length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, ${widget.session.username} 👋',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bách Hóa Online',
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Đăng xuất',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: 'Tìm rau củ, thịt cá, sữa…',
            hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      _searchCtrl.clear();
                      _onSearch('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Hero Banner (Stitch: "Fresh Every Day") ────────────────────────────
  Widget _buildHeroBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 190),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20), // deep forest green
              Color(0xFF33691E), // olive green
              Color(0xFF558B2F), // medium leaf green
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative background circles ──
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            // ── Decorative leaf icon ──
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Icon(
                Icons.eco,
                size: 110,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            // ── Content ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Badge tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      '🌾  Farm Fresh Organic Harvest',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Main headline
                  Text(
                    'Fresh Every Day',
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Sub tagline
                  Text(
                    'Sourcing organic farm-to-table\ngroceries for your family.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // CTA button
                  SizedBox(
                    height: 36,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B5E20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListPage(
                            session: widget.session,
                            onLogout: widget.onLogout,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.storefront_outlined, size: 16),
                      label: Text(
                        'Our Mission',
                        style: GoogleFonts.workSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  // ── Feature Banners (Stitch: Eco Packaging + Express Delivery) ───────────
  Widget _buildFeatureBanners(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // ── Eco Packaging ──
          Expanded(
            child: _FeatureBannerCard(
              icon: Icons.recycling,
              iconBgColor: const Color(0xFF1B5E20).withValues(alpha: 0.1),
              iconColor: const Color(0xFF2E7D32),
              title: 'Eco Packaging',
              subtitle: 'Sustainable delivery with zero-waste materials.',
              gradientColors: const [
                Color(0xFFE8F5E9),
                Color(0xFFF1F8E9),
              ],
              borderColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(width: 12),
          // ── Express Delivery ──
          Expanded(
            child: _FeatureBannerCard(
              icon: Icons.electric_bolt,
              iconBgColor: const Color(0xFFE65100).withValues(alpha: 0.1),
              iconColor: const Color(0xFFE65100),
              title: 'Express Delivery',
              subtitle: '60-minute delivery to your doorstep, guaranteed.',
              gradientColors: const [
                Color(0xFFFFF3E0),
                Color(0xFFFFF8E1),
              ],
              borderColor: const Color(0xFFE65100).withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategories(BuildContext context) {
    final theme = Theme.of(context);
    final cats = ProductService.categories.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            'Danh mục',
            style: GoogleFonts.workSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemCount: cats.length,
            itemBuilder: (ctx, i) {
              final cat = cats[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListPage(
                      session: widget.session,
                      onLogout: widget.onLogout,
                      filterCategory: cat.id,
                    ),
                  ),
                ),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, color: cat.color, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openDetail(BuildContext ctx, dynamic product) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: product,
          session: widget.session,
          onLogout: widget.onLogout,
        ),
      ),
    );
  }
}

// ── Feature Banner Card ──────────────────────────────────────────────────────
class _FeatureBannerCard extends StatelessWidget {
  const _FeatureBannerCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.borderColor,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            title,
            style: GoogleFonts.workSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF424242),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
