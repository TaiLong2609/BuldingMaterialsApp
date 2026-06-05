import 'package:app_bachhoa/models/cart_item.dart';
import 'package:app_bachhoa/models/promotion.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/screens/system user/location_picker_page.dart';
import 'package:app_bachhoa/services/cart_service.dart';
import 'package:app_bachhoa/services/order_repository.dart';
import 'package:app_bachhoa/services/order_service.dart';
import 'package:app_bachhoa/services/promotion_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartService>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          // Action row (xoá giỏ)
          if (cart.items.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _confirmClear(context, cart),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Xoá tất cả'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),

          if (cart.items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Giỏ hàng trống',
                      style: GoogleFonts.workSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thêm sản phẩm từ trang Danh mục',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Cart items list
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final item = cart.items[i];
                    return _CartItemTile(
                      item: item,
                      onRemove: () =>
                          cart.remove(item.product.id),
                      onQtyChange: (qty) =>
                          cart.updateQuantity(item.product.id, qty),
                    );
                  },
                  childCount: cart.items.length,
                ),
              ),
            ),

          // Express Delivery banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.electric_bolt, color: Color(0xFF388E3C), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Giao hàng nhanh trong 60 phút! Đặt ngay hôm nay.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF388E3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Summary card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Số mặt hàng',
                        value: '${cart.items.length}',
                      ),
                      _SummaryRow(
                        label: 'Tổng số lượng',
                        value: '${cart.itemCount}',
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Tổng tiền',
                        value: cart.formattedTotal,
                        isTotal: true,
                        totalColor: theme.colorScheme.secondary,
                      ),
                      const SizedBox(height: 20),
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
                          onPressed: () => _checkout(context, cart),
                          icon: const Icon(Icons.payment),
                          label: Text(
                            'Đặt hàng',
                            style: GoogleFonts.workSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, CartService cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xoá giỏ hàng?',
            style: GoogleFonts.workSans(fontWeight: FontWeight.w700)),
        content:
            Text('Bạn có chắc muốn xoá tất cả sản phẩm?',
                style: GoogleFonts.inter()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Huỷ')),
          FilledButton(
              onPressed: () {
                cart.clear();
                Navigator.pop(ctx);
              },
              child: const Text('Xoá')),
        ],
      ),
    );
  }

  void _checkout(BuildContext context, CartService cart) {
    final orderService = OrderService();
    final orderRepository = OrderRepository();
    final promotionRepository = PromotionRepository();

    String formatMoney(double value) {
      final s = value.toInt().toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
        buf.write(s[i]);
      }
      return '$bufđ';
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final addrCtrl = TextEditingController();
        final promoCtrl = TextEditingController();
        Promotion? appliedPromotion;
        var isSubmitting = false;
        var isCheckingPromo = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final originalTotal = cart.totalPrice;
            final discountPercent = appliedPromotion?.discountPercent ?? 0;
            final discountAmount = originalTotal * discountPercent / 100;
            final payableTotal = originalTotal - discountAmount;

            List<CartItem> discountedItems() {
              if (discountPercent <= 0) return cart.items.toList();
              final ratio = (100 - discountPercent) / 100;
              return cart.items
                  .map(
                    (item) => CartItem(
                      product: item.product.copyWith(price: item.product.price * ratio),
                      quantity: item.quantity,
                    ),
                  )
                  .toList();
            }

            return AlertDialog(
              title: Text(
                'Xác nhận đặt hàng',
                style: GoogleFonts.workSans(fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SummaryRow(label: 'Tạm tính', value: formatMoney(originalTotal)),
                    if (appliedPromotion != null)
                      _SummaryRow(
                        label: 'Giảm ${appliedPromotion!.discountPercent.toStringAsFixed(0)}%',
                        value: '-${formatMoney(discountAmount)}',
                      ),
                    const Divider(height: 20),
                    _SummaryRow(
                      label: 'Thanh toán',
                      value: formatMoney(payableTotal),
                      isTotal: true,
                      totalColor: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: promoCtrl,
                            enabled: !isSubmitting,
                            decoration: const InputDecoration(
                              labelText: 'Mã khuyến mãi',
                              prefixIcon: Icon(Icons.local_offer_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: isSubmitting || isCheckingPromo
                              ? null
                              : () async {
                                  final code = promoCtrl.text.trim();
                                  if (code.isEmpty) return;
                                  setDialogState(() => isCheckingPromo = true);
                                  final promo = await promotionRepository.findActiveByCode(code);
                                  if (!dialogContext.mounted) return;
                                  setDialogState(() {
                                    appliedPromotion = promo;
                                    isCheckingPromo = false;
                                  });
                                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        promo == null
                                            ? 'Mã khuyến mãi không hợp lệ hoặc đã tắt.'
                                            : 'Đã áp dụng mã ${promo.code}.',
                                      ),
                                    ),
                                  );
                                },
                          child: Text(isCheckingPromo ? '...' : 'Áp dụng'),
                        ),
                      ],
                    ),
                    if (appliedPromotion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${appliedPromotion!.title} • ${appliedPromotion!.code}',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.green),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addrCtrl,
                      enabled: !isSubmitting,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ giao hàng',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final picked = await Navigator.push<PickedLocation>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LocationPickerPage(initialAddress: addrCtrl.text),
                                  ),
                                );
                                if (picked == null) return;
                                addrCtrl.text = picked.address;
                                setDialogState(() {});
                              },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Tìm và chọn trên bản đồ'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                  child: const Text('Huỷ'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final items = discountedItems();
                          final address = addrCtrl.text.trim().isEmpty
                              ? 'Địa chỉ mặc định'
                              : addrCtrl.text.trim();

                          setDialogState(() => isSubmitting = true);

                          try {
                            await orderRepository.placeOrder(
                              customerName: session.username,
                              address: address,
                              items: items,
                              promotionCode: appliedPromotion?.code,
                              discountPercent: discountPercent.toDouble(),
                              discountAmount: discountAmount,
                            );

                            orderService.placeOrder(
                              customerName: session.username,
                              address: address,
                              items: items,
                              promotionCode: appliedPromotion?.code,
                              discountPercent: discountPercent.toDouble(),
                              discountAmount: discountAmount,
                            );

                            cart.clear();

                            if (!context.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  appliedPromotion == null
                                      ? '🎉 Đặt hàng thành công!'
                                      : '🎉 Đặt hàng thành công! Đã áp dụng mã ${appliedPromotion!.code}.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          } catch (error) {
                            if (!dialogContext.mounted) return;
                            setDialogState(() => isSubmitting = false);
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(content: Text('Không thể đặt hàng: $error')),
                            );
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Đặt hàng'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onQtyChange,
  });

  final dynamic item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQtyChange;

  static const _iconMap = {
    'rau-cu': Icons.eco_outlined,
    'thit-ca': Icons.set_meal_outlined,
    'do-kho': Icons.inventory_2_outlined,
    'sua-trung': Icons.egg_outlined,
    'banh-keo': Icons.bakery_dining_outlined,
    'do-uong': Icons.local_drink_outlined,
    'dong-lanh': Icons.ac_unit_outlined,
    'che-bien': Icons.restaurant_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _iconMap[item.product.category] ?? Icons.local_grocery_store_outlined,
              size: 28,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.formattedPrice,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Qty controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline,
                    size: 18, color: theme.colorScheme.error),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SmallBtn(
                    icon: Icons.remove,
                    onTap: () => onQtyChange(item.quantity - 1),
                    theme: theme,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${item.quantity}',
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  _SmallBtn(
                    icon: Icons.add,
                    onTap: () => onQtyChange(item.quantity + 1),
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn(
      {required this.icon, required this.onTap, required this.theme});
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: theme.colorScheme.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.totalColor,
  });

  final String label;
  final String value;
  final bool isTotal;
  final Color? totalColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.workSans(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: totalColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}







