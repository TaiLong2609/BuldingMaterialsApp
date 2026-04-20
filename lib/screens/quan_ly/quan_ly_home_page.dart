import 'package:flutter/material.dart';
import 'package:app_bachhoa/models/user_session.dart';

import 'nhap_hang_page.dart';
import 'ban_hang_page.dart';
import 'quan_ly_vat_lieu_page.dart';
import 'don_hang_page.dart';
import 'manager_profile_page.dart';
import 'thong_ke_page.dart';

class QuanLyHomePage extends StatelessWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const QuanLyHomePage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý hệ thống"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
        ],
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _item(
            context,
            icon: Icons.add_box,
            title: "Nhập hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NhapHangPage()),
              );
            },
          ),

          _item(
            context,
            icon: Icons.point_of_sale,
            title: "Bán hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BanHangPage()),
              );
            },
          ),

          _item(
            context,
            icon: Icons.inventory,
            title: "Quản lý vật liệu",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuanLyVatLieuPage()),
              );
            },
          ),

          _item(
            context,
            icon: Icons.receipt_long,
            title: "Đơn hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonHangPage()),
              );
            },
          ),

          /*_item(
            context,
            icon: Icons.bar_chart,
            title: "Thống kê",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThongKePage(),
                ),
              );
            },
          ),*/
          _item(
            context,
            icon: Icons.person,
            title: "Cá nhân",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManagerProfilePage(
                    session: session, //
                    onMenuSelected: (value) {},
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
