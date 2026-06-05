import 'package:app_bachhoa/models/promotion.dart';
import 'package:app_bachhoa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PromotionRepository {
  PromotionRepository({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<void> ensureTable() async {
    final db = await _databaseService.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS promotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        code TEXT NOT NULL UNIQUE,
        description TEXT NOT NULL,
        discount_percent REAL NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<List<Promotion>> getAll() async {
    await ensureTable();
    final db = await _databaseService.database;
    final rows = await db.query('promotions', orderBy: 'created_at DESC');
    return rows.map(_fromMap).toList();
  }

  Future<List<Promotion>> getActive() async {
    await ensureTable();
    final db = await _databaseService.database;
    final rows = await db.query('promotions', where: 'is_active = ?', whereArgs: [1], orderBy: 'created_at DESC');
    return rows.map(_fromMap).toList();
  }

  Future<Promotion?> findActiveByCode(String code) async {
    await ensureTable();
    final db = await _databaseService.database;
    final rows = await db.query(
      'promotions',
      where: 'UPPER(code) = ? AND is_active = ?',
      whereArgs: [code.trim().toUpperCase(), 1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromMap(rows.first);
  }

  Future<void> upsert(Promotion promotion) async {
    await ensureTable();
    final db = await _databaseService.database;
    final data = _toMap(promotion);
    if (promotion.id == null) {
      await db.insert('promotions', data, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update('promotions', data, where: 'id = ?', whereArgs: [promotion.id]);
    }
  }

  Future<void> delete(int id) async {
    await ensureTable();
    final db = await _databaseService.database;
    await db.delete('promotions', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, Object?> _toMap(Promotion p) => {
    'title': p.title,
    'code': p.code,
    'description': p.description,
    'discount_percent': p.discountPercent,
    'is_active': p.isActive ? 1 : 0,
    'created_at': p.createdAt.toIso8601String(),
  };

  Promotion _fromMap(Map<String, Object?> row) => Promotion(
    id: row['id'] as int?,
    title: row['title'] as String,
    code: row['code'] as String,
    description: row['description'] as String,
    discountPercent: (row['discount_percent'] as num).toDouble(),
    isActive: (row['is_active'] as int) == 1,
    createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}
