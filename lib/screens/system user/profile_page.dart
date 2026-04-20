import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/models/order.dart';
import 'package:app_bachhoa/services/order_service.dart';
import 'package:app_bachhoa/screens/system user/my_orders_sub_page.dart';
import 'package:app_bachhoa/screens/system user/address_page.dart';
import 'package:app_bachhoa/screens/system user/notifications_page.dart';
import 'package:app_bachhoa/screens/system user/help_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  String get _roleLabel => switch (session.role) {
        UserRole.admin => 'Quản trị viên',
        UserRole.manager => 'Quản lý Bách Hóa',
        UserRole.customer => 'Khách hàng',
      };

  String get _roleEmoji => switch (session.role) {
        UserRole.admin => '🛡️',
        UserRole.manager => '📦',
        UserRole.customer => '🛒',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial =
        session.username.isEmpty ? '?' : session.username[0].toUpperCase();

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ────────────────────────────────────
            Container(
              width: double.infinity,
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
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 32,
                bottom: 32,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.workSans(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    session.username,
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '$_roleEmoji  $_roleLabel',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats Row ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Builder(builder: (context) {
                  final orderService = OrderService();
                  final myOrders = orderService.getByCustomer(session.username);
                  final delivered = myOrders
                      .where((o) => o.status == OrderStatus.delivered)
                      .length;
                  final pending = myOrders
                      .where((o) => o.status == OrderStatus.pending)
                      .length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                          label: 'Đơn hàng',
                          value: '${myOrders.length}',
                          icon: Icons.receipt_long_outlined,
                          color: theme.colorScheme.primary),
                      _ProfileStat(
                          label: 'Đã giao',
                          value: '$delivered',
                          icon: Icons.check_circle_outline,
                          color: Colors.green),
                      _ProfileStat(
                          label: 'Đang chờ',
                          value: '$pending',
                          icon: Icons.schedule,
                          color: Colors.orange),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // ── Menu Items ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                    _ProfileMenuItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Lịch sử đơn hàng',
                      subtitle: 'Xem tất cả đơn đã đặt',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyOrdersSubPage(
                            session: session,
                            onLogout: onLogout,
                          ),
                        ),
                      ),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Địa chỉ giao hàng',
                      subtitle: 'Quản lý địa chỉ nhận hàng',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddressPage(),
                        ),
                      ),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Thông báo',
                      subtitle: 'Cài đặt thông báo đơn hàng',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsPage(),
                        ),
                      ),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Trợ giúp & Liên hệ',
                      subtitle: 'Hotline: 1800 1234',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpPage(),
                        ),
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Logout Button ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Đăng xuất',
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Đăng xuất?',
          style: GoogleFonts.workSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Bạn có chắc muốn đăng xuất không?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onLogout();
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}


class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
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
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
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
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 0.5,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}
