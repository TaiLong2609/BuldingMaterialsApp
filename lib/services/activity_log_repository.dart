import 'package:app_bachhoa/models/activity_log.dart';
import 'package:app_bachhoa/services/database_service.dart';

class ActivityLogRepository {
  ActivityLogRepository({DatabaseService? databaseService}) : _dbs = databaseService ?? DatabaseService.instance;
  final DatabaseService _dbs;
  Future<void> ensureTable() async { final db=await _dbs.database; await db.execute('''CREATE TABLE IF NOT EXISTS activity_logs(id INTEGER PRIMARY KEY AUTOINCREMENT,actor TEXT NOT NULL,action TEXT NOT NULL,detail TEXT NOT NULL,created_at TEXT NOT NULL)'''); }
  Future<void> add({required String actor, required String action, required String detail}) async { await ensureTable(); final db=await _dbs.database; await db.insert('activity_logs', {'actor':actor,'action':action,'detail':detail,'created_at':DateTime.now().toIso8601String()}); }
  Future<List<ActivityLog>> getRecent() async { await ensureTable(); final db=await _dbs.database; final rows=await db.query('activity_logs', orderBy:'created_at DESC', limit:200); return rows.map((r)=>ActivityLog(id:r['id'] as int?, actor:r['actor'] as String, action:r['action'] as String, detail:r['detail'] as String, createdAt:DateTime.tryParse(r['created_at'].toString())??DateTime.now())).toList(); }
}
