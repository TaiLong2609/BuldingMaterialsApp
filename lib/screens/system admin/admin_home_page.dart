import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({
    super.key,
    required this.session,
    required this.onMenuSelected,
  });

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      session: session,
      title: 'Trang chủ',
      onMenuSelected: onMenuSelected,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng đến với hệ thống quản lý VLXD',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatCard(
              context,
              'Tổng số người dùng',
              '1,234',
              Icons.people,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              'Đơn hàng hôm nay',
              '56',
              Icons.shopping_cart,
              theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              'Doanh thu tháng này',
              '45.6M VND',
              Icons.attach_money,
              theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 24),
            Text(
              'Hoạt động gần đây',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              context,
              'Người dùng mới đăng ký',
              'Nguyễn Văn A - 10 phút trước',
              Icons.person_add,
            ),
            _buildActivityItem(
              context,
              'Đơn hàng mới',
              'ĐH00123 - 25 phút trước',
              Icons.receipt,
            ),
            _buildActivityItem(
              context,
              'Cập nhật vật liệu',
              'Xi măng PCB30 - 1 giờ trước',
              Icons.inventory,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }
}