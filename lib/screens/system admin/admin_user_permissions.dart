import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminUserPermissionsPage extends StatelessWidget {
  const AdminUserPermissionsPage({
    super.key,
    required this.session,
    required this.onMenuSelected,
  });

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  static const _roles = [
    _RoleInfo(
      name: 'Admin',
      description: 'Quản trị hệ thống, tài khoản, vai trò, sao lưu và nhật ký. Không xử lý nghiệp vụ sản phẩm.',
      icon: Icons.admin_panel_settings_outlined,
      color: Colors.red,
      permissions: [
        'Quản lý tài khoản hệ thống',
        'Đổi vai trò truy cập',
        'Xem vai trò & quyền hạn',
        'Sao lưu & khôi phục dữ liệu',
        'Theo dõi nhật ký hoạt động',
        'Quản lý hồ sơ admin',
      ],
    ),
    _RoleInfo(
      name: 'Manager',
      description: 'Vận hành cửa hàng, kho hàng, bán hàng và khuyến mãi.',
      icon: Icons.storefront_outlined,
      color: Colors.blue,
      permissions: [
        'Quản lý sản phẩm',
        'Nhập kho và lịch sử nhập kho',
        'Bán hàng / tạo đơn',
        'Quản lý đơn hàng',
        'Quản lý mã khuyến mãi',
        'Nhà cung cấp',
        'Thống kê cửa hàng',
      ],
    ),
    _RoleInfo(
      name: 'Customer',
      description: 'Khách hàng mua sắm, đặt hàng và theo dõi đơn hàng cá nhân.',
      icon: Icons.person_outline,
      color: Colors.green,
      permissions: [
        'Xem sản phẩm',
        'Tìm kiếm sản phẩm',
        'Thêm vào giỏ hàng',
        'Áp dụng mã khuyến mãi',
        'Đặt hàng',
        'Theo dõi đơn hàng của tôi',
        'Cập nhật hồ sơ cá nhân',
      ],
    ),
  ];

  static const _permissionGroups = [
    _PermissionGroup('Tài khoản', ['Xem tài khoản', 'Thêm tài khoản', 'Sửa tài khoản', 'Xoá tài khoản', 'Đổi vai trò']),
    _PermissionGroup('Sản phẩm', ['Xem sản phẩm', 'Thêm sản phẩm', 'Sửa sản phẩm', 'Xoá sản phẩm', 'Nhập kho']),
    _PermissionGroup('Đơn hàng', ['Xem đơn hàng', 'Tạo đơn', 'Cập nhật trạng thái', 'Huỷ đơn']),
    _PermissionGroup('Khuyến mãi', ['Xem mã', 'Thêm mã', 'Sửa mã', 'Xoá mã', 'Bật/tắt mã']),
    _PermissionGroup('Hệ thống', ['Quản lý tài khoản', 'Vai trò & quyền hạn', 'Backup/Restore', 'Nhật ký hoạt động']),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      session: session,
      title: 'Vai trò & quyền hạn',
      onMenuSelected: onMenuSelected,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              color: Theme.of(context).colorScheme.surface,
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.groups_outlined), text: 'Vai trò'),
                  Tab(icon: Icon(Icons.verified_user_outlined), text: 'Quyền hạn'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _RolesTab(roles: _roles),
                  _PermissionsTab(groups: _permissionGroups),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RolesTab extends StatelessWidget {
  const _RolesTab({required this.roles});

  final List<_RoleInfo> roles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: roles.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final role = roles[index];
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: role.color.withValues(alpha: 0.12),
              child: Icon(role.icon, color: role.color),
            ),
            title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(role.description),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quyền chính',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              for (final permission in role.permissions)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(permission),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PermissionsTab extends StatelessWidget {
  const _PermissionsTab({required this.groups});

  final List<_PermissionGroup> groups;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = groups[index];
        return Card(
          child: ExpansionTile(
            leading: const Icon(Icons.security_outlined),
            title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${group.permissions.length} quyền'),
            children: [
              for (final permission in group.permissions)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.key_outlined),
                  title: Text(permission),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RoleInfo {
  const _RoleInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.permissions,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> permissions;
}

class _PermissionGroup {
  const _PermissionGroup(this.name, this.permissions);

  final String name;
  final List<String> permissions;
}

