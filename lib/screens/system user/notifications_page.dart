import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _deliveryAlerts = true;
  bool _newProducts = false;
  bool _emailNotifs = false;

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
          'Cài Đặt Thông Báo',
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
          // ── Đơn hàng ─────────────────────────────────────────
          _SectionHeader(title: 'Đơn Hàng'),
          _NotifCard(
            children: [
              _NotifToggle(
                icon: Icons.receipt_long_outlined,
                iconColor: theme.colorScheme.primary,
                title: 'Cập nhật đơn hàng',
                subtitle: 'Thông báo khi trạng thái đơn thay đổi',
                value: _orderUpdates,
                onChanged: (v) => setState(() => _orderUpdates = v),
              ),
              _Divider(),
              _NotifToggle(
                icon: Icons.local_shipping_outlined,
                iconColor: Colors.indigo,
                title: 'Thông báo giao hàng',
                subtitle: 'Cập nhật vị trí tài xế và ETA',
                value: _deliveryAlerts,
                onChanged: (v) => setState(() => _deliveryAlerts = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Ưu đãi ──────────────────────────────────────────
          _SectionHeader(title: 'Ưu Đãi & Khuyến Mãi'),
          _NotifCard(
            children: [
              _NotifToggle(
                icon: Icons.local_offer_outlined,
                iconColor: const Color(0xFFE65100),
                title: 'Khuyến mãi & Flash sale',
                subtitle: 'Nhận ưu đãi độc quyền và giảm giá',
                value: _promotions,
                onChanged: (v) => setState(() => _promotions = v),
              ),
              _Divider(),
              _NotifToggle(
                icon: Icons.fiber_new_outlined,
                iconColor: Colors.teal,
                title: 'Sản phẩm mới',
                subtitle: 'Được thông báo khi có hàng mới về',
                value: _newProducts,
                onChanged: (v) => setState(() => _newProducts = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Kênh thông báo ───────────────────────────────────
          _SectionHeader(title: 'Kênh Thông Báo'),
          _NotifCard(
            children: [
              _NotifToggle(
                icon: Icons.email_outlined,
                iconColor: Colors.blueGrey,
                title: 'Email',
                subtitle: 'Nhận tóm tắt đơn hàng qua email',
                value: _emailNotifs,
                onChanged: (v) => setState(() => _emailNotifs = v),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lưu ý
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Thông báo đẩy phụ thuộc vào cài đặt quyền trên thiết bị của bạn.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.workSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 0.5,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
    );
  }
}

class _NotifToggle extends StatelessWidget {
  const _NotifToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
