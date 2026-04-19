import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/system user/orders_page.dart';

class ProfilePage extends StatelessWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.session, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,

      // 🔥 APPBAR có nút back
      appBar: AppBar(title: const Text("Tài khoản"), centerTitle: true),

      body: Column(
        children: [
          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=5",
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  session.username,
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${session.username}@gmail.com",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 MENU
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _menuItem(
                  context,
                  icon: Icons.receipt_long,
                  title: "Lịch sử đơn hàng",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrdersPage(session: session, onLogout: onLogout),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _menuItem(
                  context,
                  icon: Icons.logout,
                  title: "Đăng xuất",
                  isLogout: true,
                  onTap: () {
                    // confirm logout cho chuyên nghiệp
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Xác nhận"),
                        content: const Text(
                          "Bạn có chắc muốn đăng xuất không?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onLogout();
                            },
                            child: const Text("Đăng xuất"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔧 Widget menu item
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red : theme.colorScheme.onSurface,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
