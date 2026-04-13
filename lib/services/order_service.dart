import 'package:app_quanlyxaydung/models/cart_item.dart';
import 'package:app_quanlyxaydung/models/order.dart';
import 'package:app_quanlyxaydung/models/product.dart';
import 'package:app_quanlyxaydung/services/product_service.dart';

class OrderService {
  // ── Singleton ─────────────────────────────────────────────────
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Order> _orders = _generateMockOrders();

  List<Order> getAll() => List.unmodifiable(_orders);

  List<Order> getByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  /// Trả về đơn hàng theo tên khách hàng (so sánh không phân biệt hoa/thường)
  List<Order> getByCustomer(String customerName) => _orders
      .where((o) =>
          o.customerName.toLowerCase() == customerName.toLowerCase())
      .toList();

  /// Trả về đơn hàng của một khách hàng lọc theo trạng thái
  List<Order> getByCustomerAndStatus(String customerName, OrderStatus status) =>
      _orders
          .where((o) =>
              o.customerName.toLowerCase() == customerName.toLowerCase() &&
              o.status == status)
          .toList();

  void placeOrder({
    required String customerName,
    required String address,
    required List<CartItem> items,
  }) {
    final order = Order(
      id: 'DH${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName,
      items: List.from(items),
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      address: address,
    );
    _orders.insert(0, order);
  }

  void updateStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;
    final old = _orders[index];
    _orders[index] = Order(
      id: old.id,
      customerName: old.customerName,
      items: old.items,
      status: status,
      createdAt: old.createdAt,
      address: old.address,
    );
  }

  static List<Order> _generateMockOrders() {
    final ps = ProductService();
    final products = ps.getAll();

    CartItem c(Product p, int qty) => CartItem(product: p, quantity: qty);

    return [
      Order(
        id: 'DH2024001',
        customerName: 'Nguyễn Văn An',
        items: [c(products[0], 20), c(products[3], 500)],
        status: OrderStatus.delivered,
        createdAt: DateTime(2024, 4, 1),
        address: '12 Lê Lợi, Quận 1, TP.HCM',
      ),
      Order(
        id: 'DH2024002',
        customerName: 'Trần Thị Bình',
        items: [c(products[6], 10), c(products[9], 5)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 5),
        address: '45 Nguyễn Huệ, Quận 1, TP.HCM',
      ),
      Order(
        id: 'DH2024003',
        customerName: 'Lê Minh Công',
        items: [c(products[11], 3), c(products[12], 2)],
        status: OrderStatus.confirmed,
        createdAt: DateTime(2024, 4, 8),
        address: '88 Trần Hưng Đạo, Quận 5, TP.HCM',
      ),
      Order(
        id: 'DH2024004',
        customerName: 'Phạm Thị Duyên',
        items: [c(products[14], 50), c(products[15], 30)],
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 4, 10),
        address: '23 Hai Bà Trưng, Quận 3, TP.HCM',
      ),
      Order(
        id: 'DH2024005',
        customerName: 'Hoàng Văn Em',
        items: [c(products[1], 15), c(products[4], 200)],
        status: OrderStatus.cancelled,
        createdAt: DateTime(2024, 4, 3),
        address: '56 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
      ),
      Order(
        id: 'DH2024006',
        customerName: 'Vũ Thị Phương',
        items: [c(products[16], 10), c(products[17], 5)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 11),
        address: '34 Cách Mạng Tháng 8, Quận 10, TP.HCM',
      ),
      Order(
        id: 'DH2024007',
        customerName: 'Đặng Văn Giang',
        items: [c(products[7], 5), c(products[8], 3)],
        status: OrderStatus.confirmed,
        createdAt: DateTime(2024, 4, 12),
        address: '78 Pasteur, Quận 1, TP.HCM',
      ),
      // ── Demo orders for 'user' account ──────────────────────
      Order(
        id: 'DH2024008',
        customerName: 'user',
        items: [c(products[0], 5), c(products[2], 10)],
        status: OrderStatus.delivered,
        createdAt: DateTime(2024, 4, 2),
        address: '99 Nguyễn Trãi, Quận 5, TP.HCM',
      ),
      Order(
        id: 'DH2024009',
        customerName: 'user',
        items: [c(products[5], 3)],
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 4, 13),
        address: '12 Lê Văn Sỹ, Quận 3, TP.HCM',
      ),
      Order(
        id: 'DH2024010',
        customerName: 'user',
        items: [c(products[10], 2), c(products[14], 20)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 11),
        address: '12 Lê Văn Sỹ, Quận 3, TP.HCM',
      ),
    ];
  }
}
