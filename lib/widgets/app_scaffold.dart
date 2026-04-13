import 'package:app_quanlyxaydung/models/user_role.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
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
        backgroundColor: theme.colorScheme.surface,
        title: Text('VLXD • $title'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(session.role.drawerHeader),
              accountEmail: Text(session.username),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  session.username.isEmpty
                      ? '?'
                      : session.username.characters.first.toUpperCase(),
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in _itemsForRole(session.role))
                    ListTile(
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

  static List<String> _itemsForRole(UserRole role) {
    return switch (role) {
      UserRole.admin => const [
        'Trang chủ',
        'Quản lý tài khoản',
        'Phân quyền người dùng',
        'Hồ sơ cá nhân',
        'Đăng xuất',
      ],
      UserRole.manager => const [
        'Trang chủ',
        'Quản lý vật liệu',
        'Đơn hàng',
        'Nhập hàng',
        'Nhà cung cấp',
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
