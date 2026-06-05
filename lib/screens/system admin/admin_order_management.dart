import 'package:app_bachhoa/models/order.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/services/order_repository.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminOrderManagementPage extends StatefulWidget {
  const AdminOrderManagementPage({super.key, required this.session, required this.onMenuSelected});

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  State<AdminOrderManagementPage> createState() => _AdminOrderManagementPageState();
}

class _AdminOrderManagementPageState extends State<AdminOrderManagementPage> {
  final _repo = OrderRepository();
  List<Order> _orders = [];
  bool _isLoading = true;
  OrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders = await _repo.getAll();
    if (!mounted) return;
    setState(() { _orders = orders; _isLoading = false; });
  }

  Future<void> _updateStatus(Order order, OrderStatus status) async {
    await _repo.updateStatus(order.id, status);
    await _loadOrders();
  }

  List<Order> get _filteredOrders {
    if (_selectedStatus == null) return _orders;
    return _orders.where((order) => order.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _filteredOrders;
    return AppScaffold(
      session: widget.session,
      title: 'Quản lý đơn hàng',
      onMenuSelected: widget.onMenuSelected,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<OrderStatus?>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Lọc tình trạng đơn',
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<OrderStatus?>(
                  value: null,
                  child: Text('Tất cả đơn hàng'),
                ),
                ...OrderStatus.values.map(
                  (status) => DropdownMenuItem<OrderStatus?>(
                    value: status,
                    child: Text('${status.emoji} ${status.label}'),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadOrders,
              child: visibleOrders.isEmpty
                    ? ListView(children: const [SizedBox(height: 220), Center(child: Text('Không có đơn hàng phù hợp.'))])
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: visibleOrders.length,
                        separatorBuilder: (_, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => _OrderTile(order: visibleOrders[index], onStatusChanged: (s) => _updateStatus(visibleOrders[index], s)),
                      ),
              ),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.onStatusChanged});

  final Order order;
  final ValueChanged<OrderStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(child: Text(order.totalItems.toString())),
        title: Text(order.id),
        subtitle: Text('${order.customerName} • ${order.formattedTotal} • ${order.status.label}'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(alignment: Alignment.centerLeft, child: Text('Địa chỉ: ${order.address}')),
          const SizedBox(height: 8),
          for (final item in order.items)
            Row(
              children: [
                Expanded(child: Text(item.product.name, overflow: TextOverflow.ellipsis)),
                Text('x${item.quantity}'),
              ],
            ),
          const SizedBox(height: 12),
          DropdownButtonFormField<OrderStatus>(
            initialValue: order.status,
            decoration: const InputDecoration(labelText: 'Cập nhật trạng thái'),
            items: OrderStatus.values.map((s) => DropdownMenuItem(value: s, child: Text('${s.emoji} ${s.label}'))).toList(),
            onChanged: (value) { if (value != null) onStatusChanged(value); },
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(order.formattedTotal, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}



