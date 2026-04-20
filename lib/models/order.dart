import 'package:app_bachhoa/models/cart_item.dart';

enum OrderStatus { pending, confirmed, shipping, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Chờ xác nhận',
    OrderStatus.confirmed => 'Đã xác nhận',
    OrderStatus.shipping => 'Đang giao',
    OrderStatus.delivered => 'Đã giao',
    OrderStatus.cancelled => 'Đã huỷ',
  };

  String get emoji => switch (this) {
    OrderStatus.pending => '⏳',
    OrderStatus.confirmed => '✅',
    OrderStatus.shipping => '🚚',
    OrderStatus.delivered => '📦',
    OrderStatus.cancelled => '❌',
  };
}

class Order {
  const Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.address,
  });

  final String id;
  final String customerName;
  final List<CartItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final String address;

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedTotal {
    final p = totalAmount.toInt();
    final s = p.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '$bufđ';
  }

  double get total {
    return items.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }
}
