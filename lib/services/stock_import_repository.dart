import 'package:app_bachhoa/services/database_service.dart';

class StockImportRecord {
  const StockImportRecord({required this.productName, required this.quantity, required this.createdAt, required this.note});
  final String productName; final int quantity; final DateTime createdAt; final String note;
}
class StockImportRepository {
  StockImportRepository({DatabaseService? databaseService}) : _dbs = databaseService ?? DatabaseService.instance;
  final DatabaseService _dbs;
  Future<void> ensureTable() async { final db=await _dbs.database; await db.execute('''CREATE TABLE IF NOT EXISTS stock_imports(id INTEGER PRIMARY KEY AUTOINCREMENT,product_id TEXT NOT NULL,product_name TEXT NOT NULL,quantity INTEGER NOT NULL,note TEXT NOT NULL,created_at TEXT NOT NULL)'''); }
  Future<void> add({required String productId, required String productName, required int quantity, String note=''}) async { await ensureTable(); final db=await _dbs.database; await db.insert('stock_imports',{'product_id':productId,'product_name':productName,'quantity':quantity,'note':note,'created_at':DateTime.now().toIso8601String()}); }
  Future<List<StockImportRecord>> getRecent() async { await ensureTable(); final db=await _dbs.database; final rows=await db.query('stock_imports', orderBy:'created_at DESC', limit:100); return rows.map((r)=>StockImportRecord(productName:r['product_name'] as String, quantity:r['quantity'] as int, note:r['note'] as String, createdAt:DateTime.tryParse(r['created_at'].toString())??DateTime.now())).toList(); }
}
