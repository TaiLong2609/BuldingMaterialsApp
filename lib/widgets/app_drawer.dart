import 'package:app_quanlyxaydung/models/user_role.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.session,
    required this.currentIndex,
    required this.onNavigate,
    required this.onLogout,
  });

  final UserSession session;
  final int currentIndex;
  final ValueChanged<int> onNavigate;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _itemsForRole(session.role);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(0)),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          _DrawerHeader(session: session),

          // ── Navigation items ───────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final isSelected = item.tabIndex == currentIndex;
                return _DrawerItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    onNavigate(item.tabIndex);
                  },
                );
              },
            ),
          ),

          // ── Divider + Logout ───────────────────────────────────
          const Divider(height: 1, thickness: 0.5),
          _LogoutTile(onLogout: () {
            Navigator.of(context).pop();
            onLogout();
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static List<_DrawerItemData> _itemsForRole(UserRole role) {
    return switch (role) {
      UserRole.admin => [
          const _DrawerItemData(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            label: 'Quản Lý Đơn Hàng',
            tabIndex: 0,
          ),
          const _DrawerItemData(
            icon: Icons.category_outlined,
            activeIcon: Icons.category,
            label: 'Danh Mục',
            tabIndex: 1,
          ),
        ],
      UserRole.manager => [
          const _DrawerItemData(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            label: 'Quản Lý Đơn Hàng',
            tabIndex: 0,
          ),
          const _DrawerItemData(
            icon: Icons.category_outlined,
            activeIcon: Icons.category,
            label: 'Danh Mục',
            tabIndex: 1,
          ),
        ],
      UserRole.customer => [
          const _DrawerItemData(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Trang Chủ',
            tabIndex: 0,
          ),
          const _DrawerItemData(
            icon: Icons.category_outlined,
            activeIcon: Icons.category,
            label: 'Danh Mục',
            tabIndex: 1,
          ),
          const _DrawerItemData(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart,
            label: 'Giỏ Hàng',
            tabIndex: 2,
          ),
          const _DrawerItemData(
            icon: Icons.list_alt_outlined,
            activeIcon: Icons.list_alt,
            label: 'Đơn Hàng Của Tôi',
            tabIndex: 3,
          ),
        ],
    };
  }
}

// ── Data class ─────────────────────────────────────────────────────────
class _DrawerItemData {
  const _DrawerItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tabIndex,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int tabIndex;
}

// ── Header Widget ──────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.session});
  final UserSession session;

  String get _roleLabel => switch (session.role) {
        UserRole.admin => 'Quản trị viên',
        UserRole.manager => 'Quản lý VLXD',
        UserRole.customer => 'Khách hàng',
      };

  String get _roleIcon => switch (session.role) {
        UserRole.admin => '🛡️',
        UserRole.manager => '📦',
        UserRole.customer => '👤',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = session.username.isEmpty
        ? '?'
        : session.username[0].toUpperCase();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Username
          Text(
            session.username,
            style: GoogleFonts.workSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_roleIcon  $_roleLabel',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav Item ───────────────────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _DrawerItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 22,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Logout tile ────────────────────────────────────────────────────────
class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  'Đăng xuất?',
                  style: GoogleFonts.workSans(fontWeight: FontWeight.w700),
                ),
                content: Text(
                  'Bạn có chắc muốn đăng xuất không?',
                  style: GoogleFonts.inter(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Huỷ'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      onLogout();
                    },
                    child: const Text('Đăng xuất'),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 22,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 16),
                Text(
                  'Đăng xuất',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
