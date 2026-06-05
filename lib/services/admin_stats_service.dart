import 'package:app_bachhoa/services/database_service.dart';

class AdminDashboardStats {
  const AdminDashboardStats({
    required this.totalUsers,
    required this.adminCount,
    required this.managerCount,
    required this.customerCount,
    required this.activityCount,
    required this.systemModules,
    required this.todayRevenue,
    required this.monthRevenue,
    required this.todayOrders,
    required this.pendingOrders,
    required this.lowStockProducts,
    required this.totalProducts,
  });

  final int totalUsers;
  final int adminCount;
  final int managerCount;
  final int customerCount;
  final int activityCount;
  final int systemModules;

  final double todayRevenue;
  final double monthRevenue;
  final int todayOrders;
  final int pendingOrders;
  final int lowStockProducts;
  final int totalProducts;
}

class AdminStatsService {
  AdminStatsService({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<AdminDashboardStats> getDashboardStats() async {
    final db = await _databaseService.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS activity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        actor TEXT NOT NULL,
        action TEXT NOT NULL,
        detail TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
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
    await db.execute('''
      CREATE TABLE IF NOT EXISTS suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS stock_imports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        note TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    Future<int> count(String sql) async => ((await db.rawQuery(sql)).first['total'] as int?) ?? 0;
    Future<double> sum(String sql) async => ((await db.rawQuery(sql)).first['value'] as num?)?.toDouble() ?? 0;

    return AdminDashboardStats(
      totalUsers: await count('SELECT COUNT(*) AS total FROM users'),
      adminCount: await count("SELECT COUNT(*) AS total FROM users WHERE role = 'admin'"),
      managerCount: await count("SELECT COUNT(*) AS total FROM users WHERE role = 'manager'"),
      customerCount: await count("SELECT COUNT(*) AS total FROM users WHERE role = 'customer'"),
      activityCount: await count('SELECT COUNT(*) AS total FROM activity_logs'),
      systemModules: 4,
      todayRevenue: await sum("SELECT COALESCE(SUM(oi.price * oi.quantity), 0) AS value FROM orders o INNER JOIN order_items oi ON oi.order_id = o.id WHERE o.status != 'cancelled' AND date(o.created_at) = date('now', 'localtime')"),
      monthRevenue: await sum("SELECT COALESCE(SUM(oi.price * oi.quantity), 0) AS value FROM orders o INNER JOIN order_items oi ON oi.order_id = o.id WHERE o.status != 'cancelled' AND strftime('%Y-%m', o.created_at) = strftime('%Y-%m', 'now', 'localtime')"),
      todayOrders: await count("SELECT COUNT(*) AS total FROM orders WHERE date(created_at) = date('now', 'localtime')"),
      pendingOrders: await count("SELECT COUNT(*) AS total FROM orders WHERE status = 'pending'"),
      lowStockProducts: await count('SELECT COUNT(*) AS total FROM products WHERE stock <= 10'),
      totalProducts: await count('SELECT COUNT(*) AS total FROM products'),
    );
  }
}

