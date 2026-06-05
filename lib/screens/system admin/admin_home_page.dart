import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/services/admin_stats_service.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key, required this.session, required this.onMenuSelected});

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      session: session,
      title: 'Trang chủ',
      onMenuSelected: onMenuSelected,
      body: FutureBuilder<AdminDashboardStats>(
        future: AdminStatsService().getDashboardStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Không thể tải thống kê: ${snapshot.error}')));
          }
          final stats = snapshot.data ?? const AdminDashboardStats(totalUsers: 0, adminCount: 0, managerCount: 0, customerCount: 0, activityCount: 0, systemModules: 0, todayRevenue: 0, monthRevenue: 0, todayOrders: 0, pendingOrders: 0, lowStockProducts: 0, totalProducts: 0);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Bảng điều khiển hệ thống',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Admin hệ thống tập trung vào tài khoản, phân quyền, sao lưu và nhật ký hoạt động.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              _stat(context, 'Tổng tài khoản', _f(stats.totalUsers), Icons.people, theme.colorScheme.primary),
              const SizedBox(height: 12),
              _stat(context, 'Tài khoản Admin', _f(stats.adminCount), Icons.admin_panel_settings_outlined, Colors.red),
              const SizedBox(height: 12),
              _stat(context, 'Tài khoản Quản lý', _f(stats.managerCount), Icons.storefront_outlined, Colors.blue),
              const SizedBox(height: 12),
              _stat(context, 'Tài khoản Khách hàng', _f(stats.customerCount), Icons.person_outline, Colors.green),
              const SizedBox(height: 12),
              _stat(context, 'Nhật ký hoạt động', _f(stats.activityCount), Icons.history_outlined, Colors.orange),
              const SizedBox(height: 12),
              _stat(context, 'Module hệ thống', _f(stats.systemModules), Icons.settings_applications_outlined, Colors.deepPurple),
              const SizedBox(height: 24),
              Text('Phạm vi quản trị', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _infoTile(context, 'Quản lý tài khoản', 'Tạo, sửa, xoá tài khoản và đổi vai trò truy cập.', Icons.manage_accounts_outlined),
              _infoTile(context, 'Vai trò & quyền hạn', 'Theo dõi mô hình Admin / Manager / Customer của hệ thống.', Icons.verified_user_outlined),
              _infoTile(context, 'Sao lưu & khôi phục', 'Bảo vệ dữ liệu hệ thống bằng backup SQLite.', Icons.backup_outlined),
              _infoTile(context, 'Nhật ký hoạt động', 'Theo dõi các thao tác quản trị quan trọng.', Icons.manage_history_outlined),
            ],
          );
        },
      ),
    );
  }

  String _f(int value) => value.toString();

  Widget _stat(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
        title: Text(title),
        subtitle: Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _infoTile(BuildContext context, String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

