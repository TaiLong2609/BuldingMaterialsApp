import 'package:flutter/material.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'admin_home_page.dart';
import 'admin_user_management.dart';
import 'admin_user_permissions.dart';
import 'admin_profile.dart';
import 'admin_backup_restore.dart';
import 'admin_order_management.dart';
import 'package:app_bachhoa/screens/quan_ly/quan_ly_vat_lieu_page.dart';
import 'package:app_bachhoa/screens/quan_ly/lich_su_nhap_kho_page.dart';
import 'package:app_bachhoa/screens/quan_ly/nha_cung_cap_page.dart';
import 'package:app_bachhoa/screens/quan_ly/quan_ly_khuyen_mai_page.dart';
import 'admin_activity_log_page.dart';

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
      case 'Quản lý sản phẩm':
        return QuanLyVatLieuPage(onExit: () => _onMenuSelected('Trang chủ'));
      case 'Quản lý đơn hàng':
        return AdminOrderManagementPage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Mã khuyến mãi':
        return const QuanLyKhuyenMaiPage();
      case 'Nhà cung cấp':
        return const NhaCungCapPage();
      case 'Lịch sử nhập kho':
        return const LichSuNhapKhoPage();
      case 'Nhật ký hoạt động':
        return AdminActivityLogPage(
          session: widget.session,
          onMenuSelected: _onMenuSelected,
        );
      case 'Sao lưu & khôi phục':
        return AdminBackupRestorePage(
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




