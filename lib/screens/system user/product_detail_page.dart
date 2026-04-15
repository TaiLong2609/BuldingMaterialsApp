import 'package:app_quanlyxaydung/models/product.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ── Review Model ──────────────────────────────────────────────────────────────
class _Review {
  final String author;
  final double rating;
  final String comment;
  final DateTime date;

  const _Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.session,
    required this.onLogout,
  });

  final Product product;
  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  // ── Mock reviews per product ──────────────────────────────────
  late final List<_Review> _reviews = _mockReviews(widget.product.id);

  static const _iconMap = {
    'xi-mang': Icons.inventory_2_outlined,
    'gach': Icons.view_module_outlined,
    'sat-thep': Icons.linear_scale,
    'cat-da': Icons.terrain_outlined,
    'son': Icons.format_paint_outlined,
    'go': Icons.carpenter,
    'ong-nuoc': Icons.water_outlined,
    'dien': Icons.bolt_outlined,
  };

  static List<_Review> _mockReviews(String productId) {
    // Seed deterministic reviews based on productId hash
    final h = productId.codeUnits.fold(0, (a, b) => a + b) % 4;
    final base = [
      _Review(
        author: 'Nguyễn Văn A',
        rating: 5,
        comment: 'Sản phẩm chất lượng tốt, đúng như mô tả. Sẽ ủng hộ lần sau!',
        date: DateTime(2024, 3, 10),
      ),
      _Review(
        author: 'Trần Thị B',
        rating: 4,
        comment: 'Hàng ok, giao nhanh. Chỉ cần cải thiện thêm bao bì.',
        date: DateTime(2024, 3, 22),
      ),
      _Review(
        author: 'Lê Minh C',
        rating: 5,
        comment:
            'Đúng chất lượng công trình, dùng xây nhà rất ổn. Recommend!',
        date: DateTime(2024, 4, 1),
      ),
      _Review(
        author: 'Phạm Đức D',
        rating: 3,
        comment: 'Tạm ổn, giá hơi cao so với ngoài thị trường.',
        date: DateTime(2024, 4, 8),
      ),
    ];
    return base.skip(h).toList() + base.take(h).toList();
  }

  double get _avgRating =>
      _reviews.isEmpty ? 0 : _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;

  void _addToCart() {
    final cart = context.read<CartService>();
    for (var i = 0; i < _quantity; i++) {
      cart.add(widget.product);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_quantity ${widget.product.unit} vào giỏ hàng'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Xem giỏ',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showWriteReview() {
    final commentCtrl = TextEditingController();
    double selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Viết đánh giá',
                style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              // Star picker
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () =>
                          setSheet(() => selectedRating = i + 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < selectedRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 36,
                          color:
                              i < selectedRating ? Colors.amber : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Chia sẻ trải nghiệm của bạn...',
                  hintStyle: GoogleFonts.inter(fontSize: 14),
                  filled: true,
                  fillColor: Theme.of(ctx).colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (commentCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _reviews.insert(
                        0,
                        _Review(
                          author: widget.session.username,
                          rating: selectedRating,
                          comment: commentCtrl.text.trim(),
                          date: DateTime.now(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Cảm ơn đánh giá của bạn!'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: Text(
                    'Gửi đánh giá',
                    style: GoogleFonts.workSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: (product.imageAsset != null && product.imageAsset!.isNotEmpty)
                    ? Image.asset(
                        product.imageAsset!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _iconMap[product.category] ?? Icons.build_outlined,
                            size: 100,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.25),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stock badge ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.stock > 100
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.stock > 100
                          ? '✓ Còn hàng (${product.stock})'
                          : '⚠ Sắp hết (${product.stock})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: product.stock > 100
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Name ─────────────────────────────────────────
                  Text(
                    product.name,
                    style: GoogleFonts.workSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Rating summary row ────────────────────────────
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < _avgRating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 18,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '${_avgRating.toStringAsFixed(1)} (${_reviews.length} đánh giá)',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Price ─────────────────────────────────────────
                  Text(
                    product.formattedPrice,
                    style: GoogleFonts.workSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Specs ─────────────────────────────────────────
                  Text(
                    'Thông số kỹ thuật',
                    style: GoogleFonts.workSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.specs.map((spec) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          spec,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // ── Description ──────────────────────────────────
                  Text(
                    'Mô tả sản phẩm',
                    style: GoogleFonts.workSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Quantity picker ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Số lượng',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        _QtyBtn(
                          icon: Icons.remove,
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$_quantity',
                            style: GoogleFonts.workSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _QtyBtn(
                          icon: Icons.add,
                          onTap: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Total row ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng:',
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatMoney(product.price * _quantity),
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── CTA buttons ──────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _addToCart,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        'Thêm vào giỏ hàng',
                        style: GoogleFonts.workSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(
                            color: theme.colorScheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        'Tiếp tục mua sắm',
                        style: GoogleFonts.workSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // ════════════════════════════════════════════════
                  // ── REVIEW SECTION ───────────────────────────────
                  // ════════════════════════════════════════════════
                  const SizedBox(height: 32),
                  _ReviewSection(
                    reviews: _reviews,
                    avgRating: _avgRating,
                    onWrite: _showWriteReview,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMoney(double amount) {
    final s = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '$bufđ';
  }
}

// ── Review Section Widget ────────────────────────────────────────────────────
class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.reviews,
    required this.avgRating,
    required this.onWrite,
  });

  final List<_Review> reviews;
  final double avgRating;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row ──────────────────────────────────────────
        Row(
          children: [
            Text(
              'Đánh giá sản phẩm',
              style: GoogleFonts.workSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onWrite,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(
                'Viết đánh giá',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Rating summary card ──────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Big number
              Column(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: GoogleFonts.workSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < avgRating.round()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reviews.length} đánh giá',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Bar chart
              Expanded(
                child: Column(
                  children: List.generate(5, (i) {
                    final star = 5 - i;
                    final count =
                        reviews.where((r) => r.rating.round() == star).length;
                    final pct =
                        reviews.isEmpty ? 0.0 : count / reviews.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 12, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('$star',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color:
                                      theme.colorScheme.onSurfaceVariant)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: theme
                                    .colorScheme.surfaceContainerHighest,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('$count',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              )),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Individual reviews ───────────────────────────────────
        if (reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Chưa có đánh giá nào. Hãy là người đầu tiên!',
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...reviews.map((r) => _ReviewCard(review: r)),
      ],
    );
  }
}

// ── Individual Review Card ────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final _Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial =
        review.author.isEmpty ? '?' : review.author[0].toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Text(
                  initial,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.author,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${review.date.day}/${review.date.month}/${review.date.year}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quantity button ───────────────────────────────────────────────────────────
class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.primary),
      ),
    );
  }
}
