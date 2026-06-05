import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import 'ban_hang_page.dart';
import 'manager_profile_page.dart';
import 'nhap_hang_page.dart';
import 'quan_ly_vat_lieu_page.dart';
import 'quan_ly_khuyen_mai_page.dart';
import 'package:app_bachhoa/screens/system admin/admin_order_management.dart';
import 'thong_ke_quan_ly_page.dart';
import 'lich_su_nhap_kho_page.dart';
import 'nha_cung_cap_page.dart';

class QuanLyHomePage extends StatelessWidget {
  const QuanLyHomePage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  void _onMenuSelected(BuildContext context, String menu) {
    if (menu == 'Đăng xuất') {
      onLogout();
      return;
    }

    final Widget? page = switch (menu) {
      'Quản lý sản phẩm' => const QuanLyVatLieuPage(),
      'Đơn hàng' => AdminOrderManagementPage(session: session, onMenuSelected: (_) {}),
      'Nhập kho' => const NhapHangPage(),
      'Mã khuyến mãi' => const QuanLyKhuyenMaiPage(),
      'Thống kê' => const ThongKeQuanLyPage(),
      'Nhà cung cấp' => const NhaCungCapPage(),
      'Lịch sử nhập kho' => const LichSuNhapKhoPage(),
      'Hồ sơ cá nhân' => ManagerProfilePage(
          session: session,
          onMenuSelected: (_) {},
        ),
      _ => null,
    };

    if (page == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      session: session,
      title: 'Quản lý cửa hàng',
      onMenuSelected: (menu) => _onMenuSelected(context, menu),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, ${session.username}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Theo dõi sản phẩm, tồn kho và đơn hàng thực phẩm mỗi ngày.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chức năng quản lý',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.08,
              children: [
                _DashboardCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Quản lý sản phẩm',
                  subtitle: 'Thực phẩm, đồ uống, hàng tươi sống',
                  color: theme.colorScheme.primary,
                  onTap: () => _onMenuSelected(context, 'Quản lý sản phẩm'),
                ),
                _DashboardCard(
                  icon: Icons.add_box_outlined,
                  title: 'Nhập kho',
                  subtitle: 'Cập nhật số lượng tồn kho',
                  color: theme.colorScheme.secondary,
                  onTap: () => _onMenuSelected(context, 'Nhập kho'),
                ),
                _DashboardCard(
                  icon: Icons.point_of_sale_outlined,
                  title: 'Bán hàng',
                  subtitle: 'Tạo giao dịch tại cửa hàng',
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BanHangPage()),
                  ),
                ),
                _DashboardCard(
                  icon: Icons.local_offer_outlined,
                  title: 'Mã khuyến mãi',
                  subtitle: 'Tạo mã giảm giá hiển thị cho khách hàng',
                  color: Colors.pink,
                  onTap: () => _onMenuSelected(context, 'Mã khuyến mãi'),
                ),
                _DashboardCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Đơn hàng',
                  subtitle: 'Xác nhận và theo dõi giao hàng',
                  color: Colors.indigo,
                  onTap: () => _onMenuSelected(context, 'Đơn hàng'),
                ),
                _DashboardCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Nhà cung cấp',
                  subtitle: 'Quản lý đối tác cung ứng hàng hóa',
                  color: Colors.brown,
                  onTap: () => _onMenuSelected(context, 'Nhà cung cấp'),
                ),
                _DashboardCard(
                  icon: Icons.history_outlined,
                  title: 'Lịch sử nhập kho',
                  subtitle: 'Theo dõi các lần nhập hàng',
                  color: Colors.cyan,
                  onTap: () => _onMenuSelected(context, 'Lịch sử nhập kho'),
                ),
                _DashboardCard(
                  icon: Icons.query_stats_outlined,
                  title: 'Thống kê',
                  subtitle: 'Doanh thu và hiệu quả bán hàng',
                  color: Colors.deepPurple,
                  onTap: () => _onMenuSelected(context, 'Thống kê'),
                ),
                _DashboardCard(
                  icon: Icons.person_outline,
                  title: 'Hồ sơ cá nhân',
                  subtitle: 'Thông tin quản lý cửa hàng',
                  color: Colors.teal,
                  onTap: () => _onMenuSelected(context, 'Hồ sơ cá nhân'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


