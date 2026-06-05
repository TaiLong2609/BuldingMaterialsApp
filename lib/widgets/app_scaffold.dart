import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.session,
    required this.title,
    required this.onMenuSelected,
    required this.body,
  });

  final UserSession session;
  final String title;
  final ValueChanged<String> onMenuSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bách Hóa Online • $title',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: theme.colorScheme.surface,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              accountName: Text(session.role.drawerHeader),
              accountEmail: Text(session.username),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.onPrimary,
                child: Text(
                  session.username.isEmpty
                      ? '?'
                      : session.username.characters.first.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in _itemsForRole(session.role))
                    ListTile(
                      leading: Icon(_iconForMenu(item)),
                      title: Text(item),
                      onTap: () {
                        Navigator.of(context).pop();
                        onMenuSelected(item);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }

  static IconData _iconForMenu(String item) {
    return switch (item) {
      'Trang chủ' => Icons.dashboard_outlined,
      'Quản lý tài khoản' => Icons.manage_accounts_outlined,
      'Phân quyền người dùng' => Icons.admin_panel_settings_outlined,
      'Sao lưu & khôi phục' => Icons.backup_outlined,
      'Hồ sơ cá nhân' => Icons.person_outline,
      'Quản lý sản phẩm' => Icons.inventory_2_outlined,
      'Quản lý đơn hàng' => Icons.receipt_long_outlined,
      'Đơn hàng' => Icons.receipt_long_outlined,
      'Nhập kho' => Icons.add_box_outlined,
      'Mã khuyến mãi' => Icons.local_offer_outlined,
      'Nhà cung cấp' => Icons.local_shipping_outlined,
      'Lịch sử nhập kho' => Icons.history_outlined,
      'Nhật ký hoạt động' => Icons.manage_history_outlined,
      'Thống kê' => Icons.query_stats_outlined,
      'Sản phẩm' => Icons.storefront_outlined,
      'Giỏ hàng' => Icons.shopping_cart_outlined,
      'Đơn hàng của tôi' => Icons.list_alt_outlined,
      'Đăng xuất' => Icons.logout,
      _ => Icons.circle_outlined,
    };
  }

  static List<String> _itemsForRole(UserRole role) {
    return switch (role) {
      UserRole.admin => const [
        'Trang chủ',
        'Quản lý tài khoản',
        'Phân quyền người dùng',
        'Nhật ký hoạt động',
        'Sao lưu & khôi phục',
        'Hồ sơ cá nhân',
        'Đăng xuất',
      ],
      UserRole.manager => const [
        'Trang chủ',
        'Quản lý sản phẩm',
        'Đơn hàng',
        'Nhập kho',
        'Mã khuyến mãi',
        'Nhà cung cấp',
        'Lịch sử nhập kho',
        'Thống kê',
        'Đăng xuất',
      ],
      UserRole.customer => const [
        'Trang chủ',
        'Sản phẩm',
        'Giỏ hàng',
        'Đơn hàng của tôi',
        'Hồ sơ cá nhân',
        'Đăng xuất',
      ],
    };
  }
}







