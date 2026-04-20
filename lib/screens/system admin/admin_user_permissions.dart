import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminUserPermissionsPage extends StatefulWidget {
  const AdminUserPermissionsPage({
    super.key,
    required this.session,
    required this.onMenuSelected,
  });

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  State<AdminUserPermissionsPage> createState() => _AdminUserPermissionsPageState();
}

class _AdminUserPermissionsPageState extends State<AdminUserPermissionsPage> {
  final _searchController = TextEditingController();

  // Mock data dựa trên schema DB
  final List<Map<String, dynamic>> _users = [
    {
      'MaTaiKhoan': 1,
      'TenDangNhap': 'admin_sys',
      'HoTen': 'Nguyễn Văn Admin',
      'Email': 'adminsys@example.com',
      'MaVaiTro': 1,
      'TenVaiTro': 'Admin Hệ Thống',
      'TrangThaiTaiKhoan': 'Hoạt động',
    },
    {
      'MaTaiKhoan': 2,
      'TenDangNhap': 'quanly_01',
      'HoTen': 'Trần Thị Quản Lý',
      'Email': 'quanly01@example.com',
      'MaVaiTro': 2,
      'TenVaiTro': 'Admin Quản Lý',
      'TrangThaiTaiKhoan': 'Hoạt động',
    },
    {
      'MaTaiKhoan': 3,
      'TenDangNhap': 'khachhang1',
      'HoTen': 'Lê Văn Khách',
      'Email': 'khachhang1@example.com',
      'MaVaiTro': 3,
      'TenVaiTro': 'User',
      'TrangThaiTaiKhoan': 'Hoạt động',
    },
  ];

  final List<Map<String, dynamic>> _roles = [
    {'MaVaiTro': 1, 'TenVaiTro': 'Admin Hệ Thống'},
    {'MaVaiTro': 2, 'TenVaiTro': 'Admin Quản Lý'},
    {'MaVaiTro': 3, 'TenVaiTro': 'User'},
  ];

  final List<Map<String, dynamic>> _functions = [
    {'MaChucNang': 1, 'TenChucNang': 'Quản lý tài khoản', 'MaChucNangCode': 'TAI_KHOAN'},
    {'MaChucNang': 2, 'TenChucNang': 'Quản lý vật liệu', 'MaChucNangCode': 'VAT_LIEU'},
    {'MaChucNang': 3, 'TenChucNang': 'Giỏ hàng', 'MaChucNangCode': 'GIO_HANG'},
    {'MaChucNang': 4, 'TenChucNang': 'Đơn hàng', 'MaChucNangCode': 'DON_HANG'},
    {'MaChucNang': 5, 'TenChucNang': 'Thanh toán', 'MaChucNangCode': 'THANH_TOAN'},
    {'MaChucNang': 6, 'TenChucNang': 'Giao hàng', 'MaChucNangCode': 'GIAO_HANG'},
    {'MaChucNang': 7, 'TenChucNang': 'Sao lưu hệ thống', 'MaChucNangCode': 'SAO_LUU'},
    {'MaChucNang': 8, 'TenChucNang': 'Phân quyền', 'MaChucNangCode': 'PHAN_QUYEN'},
  ];

  final List<Map<String, dynamic>> _permissions = [
    // Tài khoản
    {'MaQuyen': 1, 'MaChucNang': 1, 'TenQuyen': 'Xem tài khoản', 'MaQuyenCode': 'TAI_KHOAN_XEM', 'HanhDong': 'Xem'},
    {'MaQuyen': 2, 'MaChucNang': 1, 'TenQuyen': 'Thêm tài khoản', 'MaQuyenCode': 'TAI_KHOAN_THEM', 'HanhDong': 'Thêm'},
    {'MaQuyen': 3, 'MaChucNang': 1, 'TenQuyen': 'Sửa tài khoản', 'MaQuyenCode': 'TAI_KHOAN_SUA', 'HanhDong': 'Sửa'},
    {'MaQuyen': 4, 'MaChucNang': 1, 'TenQuyen': 'Xóa tài khoản', 'MaQuyenCode': 'TAI_KHOAN_XOA', 'HanhDong': 'Xóa'},
    // Vật liệu
    {'MaQuyen': 5, 'MaChucNang': 2, 'TenQuyen': 'Xem vật liệu', 'MaQuyenCode': 'VAT_LIEU_XEM', 'HanhDong': 'Xem'},
    {'MaQuyen': 6, 'MaChucNang': 2, 'TenQuyen': 'Thêm vật liệu', 'MaQuyenCode': 'VAT_LIEU_THEM', 'HanhDong': 'Thêm'},
    {'MaQuyen': 7, 'MaChucNang': 2, 'TenQuyen': 'Sửa vật liệu', 'MaQuyenCode': 'VAT_LIEU_SUA', 'HanhDong': 'Sửa'},
    {'MaQuyen': 8, 'MaChucNang': 2, 'TenQuyen': 'Xóa vật liệu', 'MaQuyenCode': 'VAT_LIEU_XOA', 'HanhDong': 'Xóa'},
    // Đơn hàng
    {'MaQuyen': 9, 'MaChucNang': 4, 'TenQuyen': 'Xem đơn hàng', 'MaQuyenCode': 'DON_HANG_XEM', 'HanhDong': 'Xem'},
    {'MaQuyen': 10, 'MaChucNang': 4, 'TenQuyen': 'Thêm đơn hàng', 'MaQuyenCode': 'DON_HANG_THEM', 'HanhDong': 'Thêm'},
    {'MaQuyen': 11, 'MaChucNang': 4, 'TenQuyen': 'Sửa đơn hàng', 'MaQuyenCode': 'DON_HANG_SUA', 'HanhDong': 'Sửa'},
    {'MaQuyen': 12, 'MaChucNang': 4, 'TenQuyen': 'Hủy đơn hàng', 'MaQuyenCode': 'DON_HANG_HUY', 'HanhDong': 'Hủy'},
    {'MaQuyen': 13, 'MaChucNang': 4, 'TenQuyen': 'Xác nhận đơn hàng', 'MaQuyenCode': 'DON_HANG_XAC_NHAN', 'HanhDong': 'Xác nhận'},
  ];

  final List<Map<String, dynamic>> _rolePermissions = [
    // Admin Hệ Thống: tất cả quyền
    {'MaVaiTro': 1, 'MaQuyen': 1, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 2, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 3, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 4, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 5, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 6, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 7, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 8, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 9, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 10, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 11, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 12, 'DuocPhep': 1},
    {'MaVaiTro': 1, 'MaQuyen': 13, 'DuocPhep': 1},
    // Admin Quản Lý: quyền vận hành
    {'MaVaiTro': 2, 'MaQuyen': 3, 'DuocPhep': 1}, // Sửa tài khoản
    {'MaVaiTro': 2, 'MaQuyen': 5, 'DuocPhep': 1}, // Xem vật liệu
    {'MaVaiTro': 2, 'MaQuyen': 6, 'DuocPhep': 1}, // Thêm vật liệu
    {'MaVaiTro': 2, 'MaQuyen': 7, 'DuocPhep': 1}, // Sửa vật liệu
    {'MaVaiTro': 2, 'MaQuyen': 9, 'DuocPhep': 1}, // Xem đơn hàng
    {'MaVaiTro': 2, 'MaQuyen': 11, 'DuocPhep': 1}, // Sửa đơn hàng
    {'MaVaiTro': 2, 'MaQuyen': 12, 'DuocPhep': 1}, // Hủy đơn hàng
    {'MaVaiTro': 2, 'MaQuyen': 13, 'DuocPhep': 1}, // Xác nhận đơn hàng
    // User: quyền mua hàng cơ bản
    {'MaVaiTro': 3, 'MaQuyen': 5, 'DuocPhep': 1}, // Xem vật liệu
    {'MaVaiTro': 3, 'MaQuyen': 10, 'DuocPhep': 1}, // Thêm đơn hàng
    {'MaVaiTro': 3, 'MaQuyen': 12, 'DuocPhep': 1}, // Hủy đơn hàng
  ];

  final List<Map<String, dynamic>> _userPermissions = [
    // Ghi đè quyền riêng cho tài khoản
  ];

  final List<Map<String, dynamic>> _permissionLogs = [
    {
      'MaNhatKy': 1,
      'LoaiDoiTuong': 'Vai trò',
      'MaDoiTuong': 1,
      'MaQuyen': 1,
      'HanhDong': 'Cấp',
      'GiaTriMoi': 1,
      'NguoiThucHien': 1,
      'ThoiGian': '2026-04-12 10:00:00',
      'GhiChu': 'Cấp quyền xem tài khoản cho Admin Hệ Thống',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      session: widget.session,
      title: 'Quản Lý Phân Quyền',
      onMenuSelected: widget.onMenuSelected,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: theme.colorScheme.surface,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Người dùng', icon: Icon(Icons.people)),
                  Tab(text: 'Vai trò', icon: Icon(Icons.group)),
                  Tab(text: 'Quyền hạn', icon: Icon(Icons.security)),
                  Tab(text: 'Nhật ký', icon: Icon(Icons.history)),
                ],
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              ),
            ),

            // Search Bar (chỉ cho tab users)
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surface,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm người dùng...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildUsersTab(),
                  _buildRolesTab(),
                  _buildPermissionsTab(),
                  _buildLogsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    final filteredUsers = _getFilteredUsers();
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserPermissionsCard(context, user);
      },
    );
  }

  Widget _buildRolesTab() {
    return ListView.builder(
      itemCount: _roles.length,
      itemBuilder: (context, index) {
        final role = _roles[index];
        return _buildRoleCard(context, role);
      },
    );
  }

  Widget _buildPermissionsTab() {
    return ListView.builder(
      itemCount: _functions.length,
      itemBuilder: (context, index) {
        final function = _functions[index];
        return _buildFunctionPermissionsCard(context, function);
      },
    );
  }

  Widget _buildLogsTab() {
    return ListView.builder(
      itemCount: _permissionLogs.length,
      itemBuilder: (context, index) {
        final log = _permissionLogs[index];
        return _buildLogCard(context, log);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    return _users.where((user) {
      return user['TenDangNhap']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          user['Email']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          user['HoTen']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  Widget _buildUserPermissionsCard(BuildContext context, Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final userPermissions = _getEffectivePermissionsForUser(user['MaTaiKhoan']);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            user['TenDangNhap'].toString().isEmpty
                ? '?'
                : user['TenDangNhap'].toString().characters.first.toUpperCase(),
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
        title: Text(user['HoTen']),
        subtitle: Text('${user['TenDangNhap']} • ${user['TenVaiTro']}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: user['TrangThaiTaiKhoan'] == 'Hoạt động'
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user['TrangThaiTaiKhoan'],
            style: TextStyle(
              color: user['TrangThaiTaiKhoan'] == 'Hoạt động' ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role Selection
                Text(
                  'Vai trò:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: user['MaVaiTro'],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem<int>(
                      value: role['MaVaiTro'],
                      child: Text(role['TenVaiTro']),
                    );
                  }).toList(),
                  onChanged: (newRoleId) {
                    if (newRoleId != null) {
                      _changeUserRole(user, newRoleId);
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Permissions
                Text(
                  'Quyền hạn hiệu lực:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...userPermissions.map((permission) {
                  return ListTile(
                    dense: true,
                    title: Text(permission['TenQuyen']),
                    subtitle: Text('${permission['TenChucNang']} • ${permission['HanhDong']}'),
                    trailing: Icon(
                      permission['DuocPhep'] == 1 ? Icons.check_circle : Icons.cancel,
                      color: permission['DuocPhep'] == 1 ? Colors.green : Colors.red,
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Override Permissions
                Text(
                  'Ghi đè quyền riêng:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._permissions.map((permission) {
                  final override = _userPermissions.firstWhere(
                    (up) => up['MaTaiKhoan'] == user['MaTaiKhoan'] && up['MaQuyen'] == permission['MaQuyen'],
                    orElse: () => <String, dynamic>{},
                  );
                  final isOverridden = override.isNotEmpty;
                  final allowed = override.isNotEmpty ? override['DuocPhep'] : 0;

                  return CheckboxListTile(
                    title: Text(permission['TenQuyen']),
                    subtitle: Text('${permission['TenChucNang']} • ${permission['HanhDong']}'),
                    value: isOverridden ? (allowed == 1) : null,
                    tristate: true,
                    onChanged: (value) {
                      _toggleUserPermissionOverride(user, permission, value);
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _resetUserOverrides(user),
                        child: const Text('Xóa ghi đè'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveUserPermissions(user),
                        child: const Text('Lưu thay đổi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, Map<String, dynamic> role) {
    final theme = Theme.of(context);
    final rolePermissions = _rolePermissions.where((rp) => rp['MaVaiTro'] == role['MaVaiTro']).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          Icons.group,
          color: theme.colorScheme.primary,
        ),
        title: Text(role['TenVaiTro']),
        subtitle: Text('${rolePermissions.length} quyền được cấp'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quyền hạn của vai trò:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._permissions.map((permission) {
                  final rolePerm = rolePermissions.firstWhere(
                    (rp) => rp['MaQuyen'] == permission['MaQuyen'],
                    orElse: () => <String, dynamic>{},
                  );
                  final hasPermission = rolePerm.isNotEmpty && rolePerm['DuocPhep'] == 1;

                  return CheckboxListTile(
                    title: Text(permission['TenQuyen']),
                    subtitle: Text('${permission['TenChucNang']} • ${permission['HanhDong']}'),
                    value: hasPermission,
                    onChanged: (value) {
                      _toggleRolePermission(role, permission, value ?? false);
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),

                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveRolePermissions(role),
                    child: const Text('Lưu thay đổi'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionPermissionsCard(BuildContext context, Map<String, dynamic> function) {
    final theme = Theme.of(context);
    final functionPermissions = _permissions.where((p) => p['MaChucNang'] == function['MaChucNang']).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          Icons.functions,
          color: theme.colorScheme.secondary,
        ),
        title: Text(function['TenChucNang']),
        subtitle: Text('${functionPermissions.length} quyền • ${function['MaChucNangCode']}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...functionPermissions.map((permission) {
                  return ListTile(
                    dense: true,
                    title: Text(permission['TenQuyen']),
                    subtitle: Text('${permission['HanhDong']} • ${permission['MaQuyenCode']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editPermission(permission),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => _addPermission(function),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm quyền mới'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, Map<String, dynamic> log) {
    final theme = Theme.of(context);
    final isGrant = log['HanhDong'] == 'Cấp';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          isGrant ? Icons.add_circle : Icons.remove_circle,
          color: isGrant ? Colors.green : Colors.red,
        ),
        title: Text('${log['LoaiDoiTuong']}: ${log['MaDoiTuong']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${log['HanhDong']} quyền: ${log['MaQuyen']}'),
            Text('Thời gian: ${log['ThoiGian']}'),
            if (log['GhiChu'] != null) Text('Ghi chú: ${log['GhiChu']}'),
          ],
        ),
        trailing: Text(
          log['NguoiThucHien'].toString(),
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEffectivePermissionsForUser(int maTaiKhoan) {
    final user = _users.firstWhere((u) => u['MaTaiKhoan'] == maTaiKhoan);
    final maVaiTro = user['MaVaiTro'];

    return _permissions.map((permission) {
      final rolePerm = _rolePermissions.firstWhere(
        (rp) => rp['MaVaiTro'] == maVaiTro && rp['MaQuyen'] == permission['MaQuyen'],
        orElse: () => <String, dynamic>{},
      );
      final userPerm = _userPermissions.firstWhere(
        (up) => up['MaTaiKhoan'] == maTaiKhoan && up['MaQuyen'] == permission['MaQuyen'],
        orElse: () => <String, dynamic>{},
      );

      final duocPhep = userPerm.isNotEmpty ? userPerm['DuocPhep'] : (rolePerm.isNotEmpty ? rolePerm['DuocPhep'] : 0);
      final nguonQuyen = userPerm.isNotEmpty ? 'TaiKhoan_Quyen' : (rolePerm.isNotEmpty ? 'VaiTro_Quyen' : 'KhongCo');

      return {
        ...permission,
        'DuocPhep': duocPhep,
        'NguonQuyen': nguonQuyen,
      };
    }).toList();
  }

  void _changeUserRole(Map<String, dynamic> user, int newRoleId) {
    setState(() {
      user['MaVaiTro'] = newRoleId;
      final role = _roles.firstWhere((r) => r['MaVaiTro'] == newRoleId);
      user['TenVaiTro'] = role['TenVaiTro'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thay đổi vai trò của ${user['HoTen']} thành ${user['TenVaiTro']}')),
    );
  }

  void _toggleUserPermissionOverride(Map<String, dynamic> user, Map<String, dynamic> permission, bool? value) {
    setState(() {
      if (value == null) {
        // Remove override
        _userPermissions.removeWhere(
          (up) => up['MaTaiKhoan'] == user['MaTaiKhoan'] && up['MaQuyen'] == permission['MaQuyen'],
        );
      } else {
        // Add or update override
        final existing = _userPermissions.firstWhere(
          (up) => up['MaTaiKhoan'] == user['MaTaiKhoan'] && up['MaQuyen'] == permission['MaQuyen'],
          orElse: () => <String, dynamic>{},
        );

        if (existing.isNotEmpty) {
          existing['DuocPhep'] = value ? 1 : 0;
          existing['NgayCapNhat'] = DateTime.now().toString();
        } else {
          _userPermissions.add({
            'MaTaiKhoan': user['MaTaiKhoan'],
            'MaQuyen': permission['MaQuyen'],
            'DuocPhep': value ? 1 : 0,
            'NgayCapNhat': DateTime.now().toString(),
            'NguoiCapNhat': 1, // Admin
            'LyDo': 'Ghi đè quyền riêng',
          });
        }
      }
    });
  }

  void _resetUserOverrides(Map<String, dynamic> user) {
    setState(() {
      _userPermissions.removeWhere((up) => up['MaTaiKhoan'] == user['MaTaiKhoan']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa tất cả ghi đè quyền riêng')),
    );
  }

  void _saveUserPermissions(Map<String, dynamic> user) {
    // TODO: Implement save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu quyền hạn cho ${user['HoTen']}')),
    );
  }

  void _toggleRolePermission(Map<String, dynamic> role, Map<String, dynamic> permission, bool enabled) {
    setState(() {
      final existing = _rolePermissions.firstWhere(
        (rp) => rp['MaVaiTro'] == role['MaVaiTro'] && rp['MaQuyen'] == permission['MaQuyen'],
        orElse: () => <String, dynamic>{},
      );

      if (existing.isNotEmpty) {
        existing['DuocPhep'] = enabled ? 1 : 0;
        existing['NgayGan'] = DateTime.now().toString();
      } else if (enabled) {
        _rolePermissions.add({
          'MaVaiTro': role['MaVaiTro'],
          'MaQuyen': permission['MaQuyen'],
          'DuocPhep': 1,
          'NgayGan': DateTime.now().toString(),
          'NguoiGan': 1, // Admin
          'GhiChu': 'Cấp quyền cho vai trò',
        });
      }
    });
  }

  void _saveRolePermissions(Map<String, dynamic> role) {
    // TODO: Implement save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu quyền hạn cho vai trò ${role['TenVaiTro']}')),
    );
  }

  void _editPermission(Map<String, dynamic> permission) {
    // TODO: Implement edit permission dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chỉnh sửa quyền: ${permission['TenQuyen']}')),
    );
  }

  void _addPermission(Map<String, dynamic> function) {
    // TODO: Implement add permission dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thêm quyền mới cho chức năng: ${function['TenChucNang']}')),
    );
  }
}