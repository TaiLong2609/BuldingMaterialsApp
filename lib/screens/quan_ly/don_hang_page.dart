import 'package:flutter/material.dart';
import 'package:app_bachhoa/services/order_service.dart';
import 'package:app_bachhoa/models/order.dart';
import 'package:google_fonts/google_fonts.dart';

class DonHangPage extends StatefulWidget {
  const DonHangPage({super.key});

  @override
  State<DonHangPage> createState() => _DonHangPageState();
}

class _DonHangPageState extends State<DonHangPage> {
  final orderService = OrderService();
  OrderStatus? selectedStatus;

  // Màu sắc bổ trợ theo trạng thái
  Color _getStatusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => Colors.orange,
    OrderStatus.confirmed => Colors.blue,
    OrderStatus.shipping => Colors.indigo,
    OrderStatus.delivered => Colors.green,
    OrderStatus.cancelled => Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Order> orders = selectedStatus == null
        ? orderService.getAll()
        : orderService.getByStatus(selectedStatus!);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          "Quản Lý Đơn Hàng",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Bộ lọc trạng thái (Đã làm đẹp lại) ─────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.surface,
            child: DropdownButtonFormField<OrderStatus?>(
              value: selectedStatus,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.filter_list),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              hint: const Text("Tất cả đơn hàng"),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("Tất cả đơn hàng"),
                ),
                ...OrderStatus.values.map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text("${status.emoji} ${status.label}"),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => selectedStatus = value),
            ),
          ),

          // ── Danh sách đơn hàng ─────────────────────
          Expanded(
            child: orders.isEmpty
                ? _buildEmptyState(theme)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _buildOrderCard(context, orders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // --- Widget Card đơn hàng chi tiết ---
  Widget _buildOrderCard(BuildContext context, Order o) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(o.status);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: ID & Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  o.id,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${o.status.emoji} ${o.status.label}",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body: Thông tin khách & Sản phẩm
          ListTile(
            title: Text(
              o.customerName,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Đã đặt ${o.items.length} mặt hàng",
                style: GoogleFonts.inter(fontSize: 12),
              ),
            ),
            trailing: PopupMenuButton<OrderStatus>(
              icon: const Icon(Icons.more_vert),
              onSelected: (newStatus) =>
                  setState(() => orderService.updateStatus(o.id, newStatus)),
              itemBuilder: (context) => OrderStatus.values.map((status) {
                return PopupMenuItem(
                  value: status,
                  child: Text("Đổi sang: ${status.label}"),
                );
              }).toList(),
            ),
          ),

          // Footer: Tổng tiền
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng thanh toán:",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  o.formattedTotal,
                  style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            "Chưa có đơn hàng nào",
            style: GoogleFonts.inter(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
