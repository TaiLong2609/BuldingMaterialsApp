import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const _databaseName = 'bach_hoa_online.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> getDatabaseFilePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, _databaseName);
  }

  Future<String> getBackupDirectoryPath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, 'backups');
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabaseFilePath();

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onOpen: (db) async {
        await _ensureSchema(db);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        unit TEXT NOT NULL,
        stock INTEGER NOT NULL,
        description TEXT NOT NULL,
        specs TEXT NOT NULL DEFAULT '[]',
        image_icon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        customer_name TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        address TEXT NOT NULL,
        promotion_code TEXT,
        discount_percent REAL NOT NULL DEFAULT 0,
        discount_amount REAL NOT NULL DEFAULT 0,
        final_total REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE promotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        code TEXT NOT NULL UNIQUE,
        description TEXT NOT NULL,
        discount_percent REAL NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
  }

  Future<void> _ensureSchema(Database db) async {
    Future<bool> hasColumn(String table, String column) async {
      final rows = await db.rawQuery('PRAGMA table_info($table)');
      return rows.any((row) => row['name'] == column);
    }

    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        customer_name TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');

    final columns = <String, String>{
      'promotion_code': 'TEXT',
      'discount_percent': 'REAL NOT NULL DEFAULT 0',
      'discount_amount': 'REAL NOT NULL DEFAULT 0',
      'final_total': 'REAL NOT NULL DEFAULT 0',
    };
    for (final entry in columns.entries) {
      if (!await hasColumn('orders', entry.key)) {
        await db.execute('ALTER TABLE orders ADD COLUMN ${entry.key} ${entry.value}');
      }
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db == null) return;
    await db.close();
    _database = null;
  }
}
