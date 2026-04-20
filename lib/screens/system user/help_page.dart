import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const _faqs = [
    _FaqItem(
      question: 'Khi nào đơn hàng của tôi được giao?',
      answer:
          'Đơn hàng thường được giao trong vòng 60 phút sau khi xác nhận trong giờ hoạt động (6:00 - 22:00). Đơn đặt ngoài giờ sẽ được giao vào sáng hôm sau.',
    ),
    _FaqItem(
      question: 'Tôi có thể huỷ đơn hàng không?',
      answer:
          'Bạn có thể huỷ đơn trong vòng 5 phút sau khi đặt, trước khi đơn được xác nhận. Vào mục "Lịch sử đơn hàng" và nhấn "Huỷ đơn".',
    ),
    _FaqItem(
      question: 'Chính sách đổi trả hàng như thế nào?',
      answer:
          'Chúng tôi chấp nhận đổi trả trong vòng 24 giờ nếu sản phẩm bị lỗi, hư hỏng hoặc không đúng mô tả. Vui lòng liên hệ hotline để được hỗ trợ.',
    ),
    _FaqItem(
      question: 'Phương thức thanh toán nào được chấp nhận?',
      answer:
          'Hiện tại chúng tôi chấp nhận: Tiền mặt khi nhận hàng (COD), chuyển khoản ngân hàng, và ví điện tử (MoMo, ZaloPay, VNPay).',
    ),
    _FaqItem(
      question: 'Làm sao để theo dõi đơn hàng?',
      answer:
          'Vào mục "Lịch sử đơn hàng" trong tab Tài khoản để xem trạng thái chi tiết của từng đơn. Bạn cũng nhận thông báo đẩy khi đơn được cập nhật.',
    ),
    _FaqItem(
      question: 'Phí giao hàng được tính như thế nào?',
      answer:
          'Miễn phí giao hàng cho đơn từ 150.000₫. Đơn dưới 150.000₫ sẽ có phí giao hàng 15.000₫. Khu vực xa trung tâm có thể phát sinh phụ phí.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Quay lại',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Trợ Giúp & Liên Hệ',
          style: GoogleFonts.workSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Liên hệ nhanh ─────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cần hỗ trợ ngay?',
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Đội ngũ hỗ trợ 24/7 sẵn sàng giúp bạn',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ContactBtn(
                        icon: Icons.phone_outlined,
                        label: 'Hotline',
                        subtitle: '1800 1234',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ContactBtn(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat ngay',
                        subtitle: 'Phản hồi tức thì',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ContactBtn(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        subtitle: 'support@bachhoa.vn',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Thông tin hoạt động ────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'THÔNG TIN CỬA HÀNG',
              style: GoogleFonts.workSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  iconColor: Colors.orange,
                  label: 'Giờ hoạt động',
                  value: '6:00 – 22:00 (Hàng ngày)',
                ),
                _HairDivider(),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  iconColor: theme.colorScheme.primary,
                  label: 'Kho hàng chính',
                  value: '25 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
                ),
                _HairDivider(),
                _InfoRow(
                  icon: Icons.electric_bolt,
                  iconColor: Colors.green,
                  label: 'Giao hàng nhanh',
                  value: 'Trong 60 phút – bán kính 10km',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── FAQ ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'CÂU HỎI THƯỜNG GẶP',
              style: GoogleFonts.workSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < _faqs.length; i++) ...[
                  _FaqTile(item: _faqs[i]),
                  if (i < _faqs.length - 1) _HairDivider(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _ContactBtn extends StatelessWidget {
  const _ContactBtn({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HairDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 0.5,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.item});
  final _FaqItem item;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(
                  widget.item.answer,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
