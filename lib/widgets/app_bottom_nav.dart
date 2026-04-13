import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/cart_page.dart';
import 'package:app_quanlyxaydung/screens/category_page.dart';
import 'package:app_quanlyxaydung/screens/home_page.dart';
import 'package:app_quanlyxaydung/screens/orders_page.dart';
import 'package:app_quanlyxaydung/services/cart_service.dart';
import 'package:app_quanlyxaydung/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isStaff =>
      widget.session.role.name == 'admin' ||
      widget.session.role.name == 'manager';

  // ─── Tiêu đề theo tab và role ────────────────────────────────
  String get _title {
    if (_isStaff) {
      return switch (_index) {
        0 => 'Quản Lý Đơn Hàng',
        _ => 'Danh Mục',
      };
    }
    return switch (_index) {
      0 => 'VLXD Store',
      1 => 'Danh Mục',
      2 => 'Giỏ Hàng',
      _ => 'Đơn Hàng',
    };
  }

  void _onDrawerNavigate(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartCount = context.watch<CartService>().itemCount;

    // ─── Pages ────────────────────────────────────────────────────
    final List<Widget> pages = _isStaff
        ? [
            OrdersPage(session: widget.session, onLogout: widget.onLogout),
            CategoryPage(session: widget.session, onLogout: widget.onLogout),
          ]
        : [
            HomePage(session: widget.session, onLogout: widget.onLogout),
            CategoryPage(session: widget.session, onLogout: widget.onLogout),
            CartPage(session: widget.session, onLogout: widget.onLogout),
            OrdersPage(session: widget.session, onLogout: widget.onLogout),
          ];

    // ─── Bottom nav destinations ──────────────────────────────────
    final List<NavigationDestination> destinations = _isStaff
        ? const [
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: 'Danh mục',
            ),
          ]
        : [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            const NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: 'Danh mục',
            ),
            NavigationDestination(
              icon: Badge(
                label: cartCount > 0 ? Text('$cartCount') : null,
                isLabelVisible: cartCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: const Icon(Icons.shopping_cart),
              label: 'Giỏ hàng',
            ),
            const NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'Đơn hàng',
            ),
          ];

    return Scaffold(
      key: _scaffoldKey,

      // ─── AppBar với hamburger ───────────────────────────────────
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          _title,
          style: GoogleFonts.workSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          // Badge giỏ hàng ở AppBar (chỉ hiện cho customer)
          if (!_isStaff)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: 'Giỏ hàng',
                  onPressed: () => setState(() => _index = 2),
                ),
                if (cartCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$cartCount',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(width: 4),
        ],
      ),

      // ─── Drawer ────────────────────────────────────────────────
      drawer: AppDrawer(
        session: widget.session,
        currentIndex: _index,
        onNavigate: _onDrawerNavigate,
        onLogout: widget.onLogout,
      ),

      // ─── Body ─────────────────────────────────────────────────
      body: IndexedStack(index: _index, children: pages),

      // ─── Bottom Navigation Bar ────────────────────────────────
      bottomNavigationBar: _buildBottomBar(theme, destinations),
    );
  }

  Widget _buildBottomBar(
      ThemeData theme, List<NavigationDestination> destinations) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: theme.colorScheme.surface,
        indicatorColor:
            theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
        destinations: destinations,
      ),
    );
  }
}
