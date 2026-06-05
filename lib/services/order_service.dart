import 'package:app_bachhoa/models/cart_item.dart';
import 'package:app_bachhoa/models/order.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/product_service.dart';

class OrderService {
  // â”€â”€ Singleton â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Order> _orders = _generateMockOrders();

  List<Order> getAll() => List.unmodifiable(_orders);

  List<Order> getByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  /// Tráº£ vá» Ä‘Æ¡n hÃ ng theo tÃªn khÃ¡ch hÃ ng (so sÃ¡nh khÃ´ng phÃ¢n biá»‡t hoa/thÆ°á»ng)
  List<Order> getByCustomer(String customerName) => _orders
      .where((o) =>
          o.customerName.toLowerCase() == customerName.toLowerCase())
      .toList();

  /// Tráº£ vá» Ä‘Æ¡n hÃ ng cá»§a má»™t khÃ¡ch hÃ ng lá»c theo tráº¡ng thÃ¡i
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
    String? promotionCode,
    double discountPercent = 0,
    double discountAmount = 0,
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
        customerName: 'Nguyá»…n VÄƒn An',
        items: [c(products[0], 5), c(products[6], 3)],
        status: OrderStatus.delivered,
        createdAt: DateTime(2024, 4, 1),
        address: '12 LÃª Lá»£i, Quáº­n 1, TP.HCM',
      ),
      Order(
        id: 'DH2024002',
        customerName: 'Tráº§n Thá»‹ BÃ¬nh',
        items: [c(products[3], 2), c(products[9], 4)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 5),
        address: '45 Nguyá»…n Huá»‡, Quáº­n 1, TP.HCM',
      ),
      Order(
        id: 'DH2024003',
        customerName: 'LÃª Minh CÃ´ng',
        items: [c(products[1], 1), c(products[4], 2)],
        status: OrderStatus.confirmed,
        createdAt: DateTime(2024, 4, 8),
        address: '88 Tráº§n HÆ°ng Äáº¡o, Quáº­n 5, TP.HCM',
      ),
      Order(
        id: 'DH2024004',
        customerName: 'Pháº¡m Thá»‹ DuyÃªn',
        items: [c(products[14], 6), c(products[7], 10)],
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 4, 10),
        address: '23 Hai BÃ  TrÆ°ng, Quáº­n 3, TP.HCM',
      ),
      Order(
        id: 'DH2024005',
        customerName: 'HoÃ ng VÄƒn Em',
        items: [c(products[2], 3), c(products[10], 2)],
        status: OrderStatus.cancelled,
        createdAt: DateTime(2024, 4, 3),
        address: '56 Äiá»‡n BiÃªn Phá»§, Quáº­n BÃ¬nh Tháº¡nh, TP.HCM',
      ),
      Order(
        id: 'DH2024006',
        customerName: 'VÅ© Thá»‹ PhÆ°Æ¡ng',
        items: [c(products[15], 5), c(products[16], 3)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 11),
        address: '34 CÃ¡ch Máº¡ng ThÃ¡ng 8, Quáº­n 10, TP.HCM',
      ),
      Order(
        id: 'DH2024007',
        customerName: 'Äáº·ng VÄƒn Giang',
        items: [c(products[5], 2), c(products[11], 3)],
        status: OrderStatus.confirmed,
        createdAt: DateTime(2024, 4, 12),
        address: '78 Pasteur, Quáº­n 1, TP.HCM',
      ),
      // â”€â”€ Demo orders for 'user' account â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      Order(
        id: 'DH2024008',
        customerName: 'user',
        items: [c(products[6], 5), c(products[9], 2)],
        status: OrderStatus.delivered,
        createdAt: DateTime(2024, 4, 2),
        address: '99 Nguyá»…n TrÃ£i, Quáº­n 5, TP.HCM',
      ),
      Order(
        id: 'DH2024009',
        customerName: 'user',
        items: [c(products[3], 3)],
        status: OrderStatus.pending,
        createdAt: DateTime(2024, 4, 13),
        address: '12 LÃª VÄƒn Sá»¹, Quáº­n 3, TP.HCM',
      ),
      Order(
        id: 'DH2024010',
        customerName: 'user',
        items: [c(products[1], 2), c(products[14], 4)],
        status: OrderStatus.shipping,
        createdAt: DateTime(2024, 4, 11),
        address: '12 LÃª VÄƒn Sá»¹, Quáº­n 3, TP.HCM',
      ),
    ];
  }
}

