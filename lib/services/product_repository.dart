import 'dart:convert';

import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/database_service.dart';
import 'package:app_bachhoa/services/product_service.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  ProductRepository({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<void> ensureSeedProducts() async {
    final db = await _databaseService.database;
    final countResult = await db.rawQuery('SELECT COUNT(*) AS total FROM products');
    final total = (countResult.first['total'] as int?) ?? 0;
    if (total > 0) return;

    final seedProducts = ProductService().getAll();
    final batch = db.batch();
    for (final product in seedProducts) {
      batch.insert(
        'products',
        _toMap(product),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Product>> getAll() async {
    await ensureSeedProducts();
    final db = await _databaseService.database;
    final rows = await db.query('products', orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(_fromMap).toList();
  }

  Future<List<Product>> getByCategory(String categoryId) async {
    await ensureSeedProducts();
    final db = await _databaseService.database;
    final rows = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [categoryId],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(_fromMap).toList();
  }

  Future<void> upsert(Product product) async {
    final db = await _databaseService.database;
    await db.insert(
      'products',
      _toMap(product),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String productId) async {
    final db = await _databaseService.database;
    await db.delete('products', where: 'id = ?', whereArgs: [productId]);
  }

  Future<Product?> findById(String productId) async {
    await ensureSeedProducts();
    final db = await _databaseService.database;
    final rows = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromMap(rows.first);
  }

  Future<Product> increaseStock(String productId, int quantity) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantity must be greater than zero');
    }

    final db = await _databaseService.database;
    return db.transaction((txn) async {
      final rows = await txn.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
        limit: 1,
      );
      if (rows.isEmpty) {
        throw StateError('Không tìm thấy sản phẩm.');
      }

      final product = _fromMap(rows.first);
      final updated = product.copyWith(stock: product.stock + quantity);
      await txn.update(
        'products',
        _toMap(updated),
        where: 'id = ?',
        whereArgs: [productId],
      );
      return updated;
    });
  }

  Map<String, Object?> _toMap(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'category': product.category,
      'price': product.price,
      'unit': product.unit,
      'stock': product.stock,
      'description': product.description,
      'specs': jsonEncode(product.specs),
      'image_icon': product.imageIcon,
    };
  }

  Product _fromMap(Map<String, Object?> map) {
    final specsRaw = map['specs']?.toString() ?? '[]';
    List<String> specs;
    try {
      final decoded = jsonDecode(specsRaw);
      specs = decoded is List ? decoded.map((e) => e.toString()).toList() : <String>[];
    } catch (_) {
      specs = <String>[];
    }

    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      unit: map['unit'] as String,
      stock: map['stock'] as int,
      description: map['description'] as String,
      specs: specs,
      imageIcon: map['image_icon'] as String?,
    );
  }
}
