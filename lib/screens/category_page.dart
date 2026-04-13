import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/product_list_page.dart';
import 'package:app_quanlyxaydung/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ProductService.categories;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          // Stats header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              color: theme.colorScheme.surfaceContainerLow,
              child: Text(
                'Chọn danh mục',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(
                    label: 'Danh mục',
                    value: '${categories.length}',
                    icon: Icons.category,
                    color: theme.colorScheme.primary,
                  ),
                  _StatChip(
                    label: 'Sản phẩm',
                    value: '${categories.fold(0, (s, c) => s + c.productCount)}',
                    icon: Icons.inventory_2_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                  _StatChip(
                    label: 'Thương hiệu',
                    value: '12+',
                    icon: Icons.verified_outlined,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Grid of categories
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _CategoryCard(
                  category: categories[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListPage(
                        session: session,
                        onLogout: onLogout,
                        filterCategory: categories[i].id,
                        categoryName: categories[i].name,
                      ),
                    ),
                  ),
                ),
                childCount: categories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final dynamic category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, color: category.color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: GoogleFonts.workSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${category.productCount} sản phẩm',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
