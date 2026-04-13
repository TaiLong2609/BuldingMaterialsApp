import 'package:app_quanlyxaydung/models/order.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _orderService = OrderService();

  final _tabs = const [
    Tab(text: 'Tất cả'),
    Tab(text: 'Chờ xác nhận'),
    Tab(text: 'Đang giao'),
    Tab(text: 'Đã giao'),
    Tab(text: 'Đã huỷ'),
  ];

  final _statusFilters = [
    null,
    OrderStatus.pending,
    OrderStatus.shipping,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isManager =
        widget.session.role.name == 'admin' ||
        widget.session.role.name == 'manager';
    final username = widget.session.username;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Column(
        children: [
          // ── TabBar ────────────────────────────────────────────
          Material(
            color: theme.colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              tabs: _tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: theme.colorScheme.secondary,
              indicatorWeight: 3,
            ),
          ),

          // ── Stats banner ──────────────────────────────────────
          _buildStatsBanner(context, isManager, username),

          // ── Tab content ───────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (i) {
                final status = _statusFilters[i];
                final orders = isManager
                    ? (status == null
                        ? _orderService.getAll()
                        : _orderService.getByStatus(status))
                    : (status == null
                        ? _orderService.getByCustomer(username)
                        : _orderService.getByCustomerAndStatus(
                            username, status));
                return _buildOrderList(context, orders, isManager);
              }),
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildStatsBanner(BuildContext context, bool isManager, String username) {
    final theme = Theme.of(context);
    // Lấy đố liệu theo scope: tất cả hoặc của riêng user
    final all = isManager
        ? _orderService.getAll()
        : _orderService.getByCustomer(username);
    final pending =
        all.where((o) => o.status == OrderStatus.pending).length;
    final shipping =
        all.where((o) => o.status == OrderStatus.shipping).length;
    final delivered =
        all.where((o) => o.status == OrderStatus.delivered).length;

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBox(
            label: 'Chờ xác nhận',
            value: '$pending',
            color: Colors.orange,
            icon: Icons.schedule,
          ),
          _StatBox(
            label: 'Đang giao',
            value: '$shipping',
            color: Colors.blue,
            icon: Icons.local_shipping_outlined,
          ),
          _StatBox(
            label: 'Đã giao',
            value: '$delivered',
            color: Colors.green,
            icon: Icons.check_circle_outline,
          ),
          _StatBox(
            label: 'Tổng cộng',
            value: '${all.length}',
            color: theme.colorScheme.primary,
            icon: Icons.receipt_long_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
      BuildContext context, List<Order> orders, bool isManager) {
    final theme = Theme.of(context);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Không có đơn hàng',
              style: GoogleFonts.inter(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _OrderCard(
        order: orders[i],
        isManager: isManager,
        onStatusChange: isManager
            ? (status) {
                setState(() {
                  _orderService.updateStatus(orders[i].id, status);
                });
              }
            : null,
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.workSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            )),
        Text(label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.isManager,
    this.onStatusChange,
  });

  final Order order;
  final bool isManager;
  final ValueChanged<OrderStatus>? onStatusChange;

  Color _statusColor(OrderStatus s) => switch (s) {
        OrderStatus.pending => Colors.orange,
        OrderStatus.confirmed => Colors.blue,
        OrderStatus.shipping => Colors.indigo,
        OrderStatus.delivered => Colors.green,
        OrderStatus.cancelled => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(order.status);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        order.customerName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${order.status.emoji} ${order.status.label}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                for (final item in order.items.take(2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          '• ${item.product.name}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'x${item.quantity}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (order.items.length > 2)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '+ ${order.items.length - 2} sản phẩm khác',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.address,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  order.formattedTotal,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Manager actions
          if (isManager && order.status != OrderStatus.delivered &&
              order.status != OrderStatus.cancelled)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  if (order.status == OrderStatus.pending) ...[
                    Expanded(
                      child: _ActionBtn(
                        label: 'Xác nhận',
                        color: Colors.blue,
                        icon: Icons.check,
                        onTap: () =>
                            onStatusChange?.call(OrderStatus.confirmed),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionBtn(
                        label: 'Huỷ đơn',
                        color: Colors.red,
                        icon: Icons.close,
                        onTap: () =>
                            onStatusChange?.call(OrderStatus.cancelled),
                      ),
                    ),
                  ] else if (order.status == OrderStatus.confirmed) ...[
                    Expanded(
                      child: _ActionBtn(
                        label: 'Bắt đầu giao',
                        color: Colors.indigo,
                        icon: Icons.local_shipping_outlined,
                        onTap: () =>
                            onStatusChange?.call(OrderStatus.shipping),
                      ),
                    ),
                  ] else if (order.status == OrderStatus.shipping) ...[
                    Expanded(
                      child: _ActionBtn(
                        label: 'Đã giao xong',
                        color: Colors.green,
                        icon: Icons.check_circle_outline,
                        onTap: () =>
                            onStatusChange?.call(OrderStatus.delivered),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label,
            style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
