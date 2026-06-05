import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class UserRecord {
  const UserRecord({
    this.id,
    required this.username,
    required this.password,
    required this.role,
    this.createdAt,
  });

  final int? id;
  final String username;
  final String password;
  final UserRole role;
  final DateTime? createdAt;
}

class UserRepository {
  UserRepository({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<List<UserRecord>> getAll() async {
    final db = await _databaseService.database;
    final rows = await db.query('users', orderBy: 'created_at DESC');
    return rows.map(_fromMap).toList();
  }

  Future<UserRecord?> findByUsername(String username) async {
    final db = await _databaseService.database;
    final rows = await db.query('users', where: 'username = ?', whereArgs: [username], limit: 1);
    if (rows.isEmpty) return null;
    return _fromMap(rows.first);
  }

  Future<bool> exists(String username) async => (await findByUsername(username)) != null;

  Future<void> insertUser({required String username, required String password, required UserRole role}) async {
    final db = await _databaseService.database;
    await db.insert('users', {
      'username': username,
      'password': password,
      'role': role.name,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> updateUser({required int id, required String username, required String password, required UserRole role}) async {
    final db = await _databaseService.database;
    await db.update('users', {'username': username, 'password': password, 'role': role.name}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await _databaseService.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  UserRecord _fromMap(Map<String, Object?> row) => UserRecord(
    id: row['id'] as int?,
    username: row['username'] as String,
    password: row['password'] as String,
    role: _roleFromDb(row['role'] as String),
    createdAt: DateTime.tryParse(row['created_at']?.toString() ?? ''),
  );

  UserRole _roleFromDb(String value) => switch (value) {
    'admin' => UserRole.admin,
    'manager' => UserRole.manager,
    _ => UserRole.customer,
  };
}
