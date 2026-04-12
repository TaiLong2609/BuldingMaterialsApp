import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/systeam%20admin/admin_backup_restore.dart';
import 'package:app_quanlyxaydung/screens/systeam%20admin/admin_home_page.dart';
import 'package:app_quanlyxaydung/screens/systeam%20admin/admin_profile.dart';
import 'package:app_quanlyxaydung/screens/systeam%20admin/admin_user_management.dart';
import 'package:app_quanlyxaydung/screens/systeam%20admin/admin_user_permissions.dart';
import 'package:app_quanlyxaydung/screens/login_page.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.authService});

  final AuthService authService;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  UserSession? _session;
  String _currentPage = 'Trang chủ';

  void _onLoggedIn(UserSession session) {
    setState(() {
      _session = session;
      _currentPage = 'Trang chủ';
    });
  }

  void _onMenuSelected(String menuItem) {
    if (menuItem == 'Đăng xuất') {
      _logout();
    } else {
      setState(() {
        _currentPage = menuItem;
      });
    }
  }

  void _logout() {
    setState(() {
      _session = null;
      _currentPage = 'Trang chủ';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );

    return MaterialApp(
      title: 'VLXD',
      theme: theme,
      home: _session == null
          ? LoginPage(authService: widget.authService, onLoggedIn: _onLoggedIn)
          : _buildMainPage(),
    );
  }

  Widget _buildMainPage() {
    final session = _session!;
    switch (_currentPage) {
      case 'Trang chủ':
        return AdminHomePage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Quản lý tài khoản':
        return AdminUserManagementPage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Phân quyền người dùng':
        return AdminUserPermissionsPage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Hồ sơ cá nhân':
        return AdminProfilePage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Back up và Restore dữ liệu':
        return AdminBackupRestorePage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
      default:
        return AdminHomePage(
          session: session,
          onMenuSelected: _onMenuSelected,
        );
    }
  }
}
