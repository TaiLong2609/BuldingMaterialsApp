import 'package:app_bachhoa/models/supplier.dart';
import 'package:app_bachhoa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class SupplierRepository {
  SupplierRepository({DatabaseService? databaseService}) : _dbs = databaseService ?? DatabaseService.instance;
  final DatabaseService _dbs;
  Future<void> ensureTable() async { final db=await _dbs.database; await db.execute('''CREATE TABLE IF NOT EXISTS suppliers(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,phone TEXT NOT NULL,address TEXT NOT NULL,note TEXT NOT NULL)'''); }
  Future<List<Supplier>> getAll() async { await ensureTable(); final db=await _dbs.database; final rows=await db.query('suppliers', orderBy:'name COLLATE NOCASE'); return rows.map((r)=>Supplier(id:r['id'] as int?, name:r['name'] as String, phone:r['phone'] as String, address:r['address'] as String, note:r['note'] as String)).toList(); }
  Future<void> upsert(Supplier s) async { await ensureTable(); final db=await _dbs.database; final m={'name':s.name,'phone':s.phone,'address':s.address,'note':s.note}; if(s.id==null){await db.insert('suppliers',m,conflictAlgorithm:ConflictAlgorithm.replace);}else{await db.update('suppliers',m,where:'id=?',whereArgs:[s.id]);}}
  Future<void> delete(int id) async { await ensureTable(); final db=await _dbs.database; await db.delete('suppliers',where:'id=?',whereArgs:[id]); }
}
