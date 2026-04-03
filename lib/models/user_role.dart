enum UserRole { admin, manager, customer }

extension UserRoleLabel on UserRole {
  String get drawerHeader {
    return switch (this) {
      UserRole.admin => '👤 ADMIN HỆ THỐNG',
      UserRole.manager => '📦 QUẢN LÝ VLXD\n👤 QUẢN LÝ',
      UserRole.customer => '📦 👤 KHÁCH HÀNG',
    };
  }
}
