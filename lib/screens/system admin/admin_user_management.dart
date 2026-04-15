import 'package:app_quanlyxaydung/models/user_role.dart';
import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({
    super.key,
    required this.session,
    required this.onMenuSelected,
  });

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  State<AdminUserManagementPage> createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  final _searchController = TextEditingController();
  String _selectedRole = 'Tất cả';

  // Mock data - thay thế bằng dữ liệu thực từ API
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'username': 'admin',
      'email': 'admin@example.com',
      'role': UserRole.admin,
      'status': 'active',
      'createdAt': '2024-01-01',
    },
    {
      'id': '2',
      'username': 'manager1',
      'email': 'manager1@example.com',
      'role': UserRole.manager,
      'status': 'active',
      'createdAt': '2024-01-15',
    },
    {
      'id': '3',
      'username': 'customer1',
      'email': 'customer1@example.com',
      'role': UserRole.customer,
      'status': 'inactive',
      'createdAt': '2024-02-01',
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
    final filteredUsers = _getFilteredUsers();

    return AppScaffold(
      session: widget.session,
      title: 'Quản lý Người dùng',
      onMenuSelected: widget.onMenuSelected,
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Lọc theo vai trò:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ['Tất cả', 'Admin', 'Manager', 'Customer']
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _buildUserCard(context, user);
              },
            ),
          ),

          // Add User Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _showAddUserDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm người dùng mới'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    return _users.where((user) {
      final matchesSearch = user['username']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          user['email']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      final matchesRole = _selectedRole == 'Tất cả' ||
          user['role'].toString().split('.').last.toUpperCase() ==
              _selectedRole.toUpperCase();

      return matchesSearch && matchesRole;
    }).toList();
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final role = user['role'] as UserRole;
    final status = user['status'] as String;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            user['username'].toString().isEmpty
                ? '?'
                : user['username'].toString().characters.first.toUpperCase(),
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
        title: Text(user['username']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRoleColor(role).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getRoleLabel(role),
                    style: TextStyle(
                      color: _getRoleColor(role),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: status == 'active'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status == 'active' ? 'Hoạt động' : 'Không hoạt động',
                    style: TextStyle(
                      color: status == 'active' ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleUserAction(value, user),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Chỉnh sửa'),
            ),
            const PopupMenuItem(
              value: 'toggle_status',
              child: Text('Thay đổi trạng thái'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Xóa'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    return switch (role) {
      UserRole.admin => Colors.red,
      UserRole.manager => Colors.blue,
      UserRole.customer => Colors.green,
    };
  }

  String _getRoleLabel(UserRole role) {
    return switch (role) {
      UserRole.admin => 'ADMIN',
      UserRole.manager => 'MANAGER',
      UserRole.customer => 'CUSTOMER',
    };
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'toggle_status':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _showDeleteConfirmation(user);
        break;
    }
  }

  void _showAddUserDialog() {
    // TODO: Implement add user dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng thêm người dùng đang được phát triển')),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    // TODO: Implement edit user dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chỉnh sửa người dùng: ${user['username']}')),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['status'] = user['status'] == 'active' ? 'inactive' : 'active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã ${user['status'] == 'active' ? 'kích hoạt' : 'vô hiệu hóa'} người dùng ${user['username']}',
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa người dùng ${user['username']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _users.remove(user);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa người dùng ${user['username']}')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}