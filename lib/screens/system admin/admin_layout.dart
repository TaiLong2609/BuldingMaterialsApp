import 'package:flutter/material.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'admin_home_page.dart';
import 'admin_user_management.dart';
import 'admin_user_permissions.dart';
import 'admin_profile.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  String _currentMenu = 'Trang chủ';

  void _onMenuSelected(String menu) {
    if (menu == 'Đăng xuất') {
      widget.onLogout();
      return;
    }
    setState(() {
      _currentMenu = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentMenu) {
      case 'Trang chủ':
        return AdminHomePage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Quản lý tài khoản':
        return AdminUserManagementPage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Phân quyền người dùng':
        return AdminUserPermissionsPage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Hồ sơ cá nhân':
        return AdminProfilePage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      default:
        return AdminHomePage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
    }
  }
}
