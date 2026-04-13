import 'package:app_quanlyxaydung/app/theme.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/system_admin/admin_backup_restore.dart';
import 'package:app_quanlyxaydung/screens/system_admin/admin_home_page.dart';
import 'package:app_quanlyxaydung/screens/system_admin/admin_profile.dart';
import 'package:app_quanlyxaydung/screens/system_admin/admin_user_management.dart';
import 'package:app_quanlyxaydung/screens/system_admin/admin_user_permissions.dart';
import 'package:app_quanlyxaydung/screens/system user/login_page.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';
import 'package:app_quanlyxaydung/services/cart_service.dart';
import 'package:app_quanlyxaydung/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.authService});

  final AuthService authService;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  UserSession? _session;

  void _onLoggedIn(UserSession session) {
    setState(() {
      _session = session;
    });
  }

  void _logout() {
    setState(() {
      _session = null;
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
