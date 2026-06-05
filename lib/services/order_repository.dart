import 'package:app_bachhoa/models/cart_item.dart';
import 'package:app_bachhoa/models/order.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/database_service.dart';
import 'package:app_bachhoa/services/product_repository.dart';
import 'package:sqflite/sqflite.dart';

class OrderRepository {
  OrderRepository({DatabaseService? databaseService, ProductRepository? productRepository})
    : _databaseService = databaseService ?? DatabaseService.instance,
      _productRepository = productRepository ?? ProductRepository();

  final DatabaseService _databaseService;
  final ProductRepository _productRepository;

  Future<Order> placeOrder({
    required String customerName,
    required String address,
    required List<CartItem> items,
    String? promotionCode,
    double discountPercent = 0,
    double discountAmount = 0,
  }) async {
    if (items.isEmpty) throw StateError('Giỏ hàng đang trống.');
    await _productRepository.ensureSeedProducts();
    final db = await _databaseService.database;
    final now = DateTime.now();
    final order = Order(
      id: 'DH${now.millisecondsSinceEpoch}',
      customerName: customerName,
      items: List<CartItem>.from(items),
      status: OrderStatus.pending,
      createdAt: now,
      address: address,
    );

    await db.transaction((txn) async {
      final normalizedPromotionCode = promotionCode?.trim().toUpperCase();
      if (normalizedPromotionCode != null && normalizedPromotionCode.isNotEmpty) {
        final promoRows = await txn.query(
          'promotions',
          where: 'UPPER(code) = ? AND is_active = ?',
          whereArgs: [normalizedPromotionCode, 1],
          limit: 1,
        );
        if (promoRows.isEmpty) {
          throw StateError('Mã khuyến mãi không hợp lệ hoặc đã bị tắt.');
        }
      }

      await txn.insert('orders', {
        'id': order.id,
        'customer_name': order.customerName,
        'status': order.status.name,
        'created_at': order.createdAt.toIso8601String(),
        'address': order.address,
        'promotion_code': normalizedPromotionCode?.isEmpty == true ? null : normalizedPromotionCode,
        'discount_percent': discountPercent,
        'discount_amount': discountAmount,
        'final_total': items.fold<double>(0, (sum, item) => sum + item.product.price * item.quantity),
      }, conflictAlgorithm: ConflictAlgorithm.abort);

      for (final item in items) {
        final productRows = await txn.query('products', columns: ['stock'], where: 'id = ?', whereArgs: [item.product.id], limit: 1);
        if (productRows.isEmpty) throw StateError('Không tìm thấy sản phẩm ${item.product.name} trong database.');
        final currentStock = productRows.first['stock'] as int;

        final affectedRows = await txn.rawUpdate(
          'UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?',
          [item.quantity, item.product.id, item.quantity],
        );
        if (affectedRows != 1) {
          throw StateError('Sản phẩm ${item.product.name} chỉ còn $currentStock trong kho.');
        }

        await txn.insert('order_items', {'order_id': order.id, 'product_id': item.product.id, 'quantity': item.quantity, 'price': item.product.price});
      }
    });
    return order;
  }

  Future<List<Order>> getAll() async {
    final db = await _databaseService.database;
    final rows = await db.query('orders', orderBy: 'created_at DESC');
    final result = <Order>[];
    for (final row in rows) {
      result.add(await _orderFromMap(row));
    }
    return result;
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final db = await _databaseService.database;
    await db.transaction((txn) async {
      final rows = await txn.query('orders', columns: ['status'], where: 'id = ?', whereArgs: [orderId], limit: 1);
      if (rows.isEmpty) throw StateError('Không tìm thấy đơn hàng $orderId.');
      final current = _statusFromDb(rows.first['status'] as String);
      if (!_canChangeStatus(current, status)) {
        throw StateError('Không thể chuyển đơn từ ${current.label} sang ${status.label}.');
      }
      await txn.update('orders', {'status': status.name}, where: 'id = ?', whereArgs: [orderId]);
    });
  }

  bool _canChangeStatus(OrderStatus current, OrderStatus next) {
    if (current == next) return true;
    if (current == OrderStatus.delivered || current == OrderStatus.cancelled) return false;
    return switch (current) {
      OrderStatus.pending => next == OrderStatus.confirmed || next == OrderStatus.cancelled,
      OrderStatus.confirmed => next == OrderStatus.shipping || next == OrderStatus.cancelled,
      OrderStatus.shipping => next == OrderStatus.delivered || next == OrderStatus.cancelled,
      OrderStatus.delivered || OrderStatus.cancelled => false,
    };
  }

  Future<Order> _orderFromMap(Map<String, Object?> row) async {
    final db = await _databaseService.database;
    final itemRows = await db.rawQuery('''
      SELECT oi.quantity, oi.price, p.id, p.name, p.category, p.unit, p.stock, p.description, p.specs, p.image_icon
      FROM order_items oi
      LEFT JOIN products p ON p.id = oi.product_id
      WHERE oi.order_id = ?
    ''', [row['id']]);

    final items = itemRows.map((item) {
      final product = Product(
        id: item['id']?.toString() ?? '',
        name: item['name']?.toString() ?? 'Sản phẩm đã xoá',
        category: item['category']?.toString() ?? '',
        price: (item['price'] as num).toDouble(),
        unit: item['unit']?.toString() ?? 'món',
        stock: (item['stock'] as int?) ?? 0,
        description: item['description']?.toString() ?? '',
        imageIcon: item['image_icon'] as String?,
      );
      return CartItem(product: product, quantity: item['quantity'] as int);
    }).toList();

    return Order(
      id: row['id'] as String,
      customerName: row['customer_name'] as String,
      items: items,
      status: _statusFromDb(row['status'] as String),
      createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
      address: row['address'] as String,
    );
  }

  OrderStatus _statusFromDb(String value) => switch (value) {
    'confirmed' => OrderStatus.confirmed,
    'shipping' => OrderStatus.shipping,
    'delivered' => OrderStatus.delivered,
    'cancelled' => OrderStatus.cancelled,
    _ => OrderStatus.pending,
  };
}
