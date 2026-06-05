import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/services/user_repository.dart';
import 'package:app_bachhoa/services/activity_log_repository.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key, required this.session, required this.onMenuSelected});

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  State<AdminUserManagementPage> createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  final _repo = UserRepository();
  final _logRepo = ActivityLogRepository();
  final _searchController = TextEditingController();
  List<UserRecord> _users = [];
  String _selectedRole = 'Tất cả';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _repo.getAll();
    if (!mounted) return;
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  List<UserRecord> _filteredUsers() {
    final q = _searchController.text.trim().toLowerCase();
    return _users.where((user) {
      final matchSearch = q.isEmpty || user.username.toLowerCase().contains(q) || user.role.name.contains(q);
      final matchRole = _selectedRole == 'Tất cả' || user.role.name == _selectedRole.toLowerCase();
      return matchSearch && matchRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final users = _filteredUsers();

    return AppScaffold(
      session: widget.session,
      title: 'Quản lý tài khoản',
      onMenuSelected: widget.onMenuSelected,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tài khoản...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Lọc theo vai trò'),
                  items: const ['Tất cả', 'Admin', 'Manager', 'Customer']
                      .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedRole = value ?? 'Tất cả'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                    ? const Center(child: Text('Không có tài khoản phù hợp.'))
                    : RefreshIndicator(
                        onRefresh: _loadUsers,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: users.length,
                          itemBuilder: (context, index) => _buildUserCard(theme, users[index]),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: () => _showUserDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm tài khoản'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(ThemeData theme, UserRecord user) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _roleColor(user.role).withValues(alpha: 0.12),
          child: Icon(_roleIcon(user.role), color: _roleColor(user.role)),
        ),
        title: Text(user.username),
        subtitle: Text('${_roleLabel(user.role)} • ${_formatDate(user.createdAt)}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _showUserDialog(user: user);
            if (value == 'delete') _confirmDelete(user);
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Sửa')),
            PopupMenuItem(value: 'delete', child: Text('Xoá')),
          ],
        ),
      ),
    );
  }

  Future<void> _showUserDialog({UserRecord? user}) async {
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final passwordCtrl = TextEditingController(text: user?.password ?? '');
    var role = user?.role ?? UserRole.customer;
    UserRecord? saved;

    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(user == null ? 'Thêm tài khoản' : 'Sửa tài khoản'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Tên đăng nhập')),
                const SizedBox(height: 12),
                TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Mật khẩu')),
                const SizedBox(height: 12),
                DropdownButtonFormField<UserRole>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Vai trò'),
                  items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(_roleLabel(r)))).toList(),
                  onChanged: (value) => setDialogState(() => role = value ?? UserRole.customer),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Huỷ')),
              FilledButton(
                onPressed: () {
                  final username = usernameCtrl.text.trim();
                  final password = passwordCtrl.text;
                  if (username.isEmpty || password.isEmpty) return;
                  saved = UserRecord(id: user?.id, username: username, password: password, role: role, createdAt: user?.createdAt);
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      );
      if (ok != true || saved == null) return;
      if (saved!.id == null) {
        await _repo.insertUser(username: saved!.username, password: saved!.password, role: saved!.role);
        await _logRepo.add(actor: widget.session.username, action: 'Thêm tài khoản', detail: 'Tạo tài khoản ');
      } else {
        await _repo.updateUser(id: saved!.id!, username: saved!.username, password: saved!.password, role: saved!.role);
        await _logRepo.add(actor: widget.session.username, action: 'Sửa tài khoản', detail: 'Cập nhật tài khoản ');
      }
      await _loadUsers();
    } finally {
      usernameCtrl.dispose();
      passwordCtrl.dispose();
    }
  }

  Future<void> _confirmDelete(UserRecord user) async {
    if (user.id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá tài khoản'),
        content: Text('Bạn có chắc muốn xoá ${user.username}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xoá')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteUser(user.id!);
    await _logRepo.add(actor: widget.session.username, action: 'Xoá tài khoản', detail: 'Xoá tài khoản ');
    await _loadUsers();
  }

  Color _roleColor(UserRole role) => switch (role) { UserRole.admin => Colors.red, UserRole.manager => Colors.blue, UserRole.customer => Colors.green };
  IconData _roleIcon(UserRole role) => switch (role) { UserRole.admin => Icons.admin_panel_settings, UserRole.manager => Icons.store, UserRole.customer => Icons.person };
  static String _roleLabel(UserRole role) => switch (role) { UserRole.admin => 'Admin', UserRole.manager => 'Manager', UserRole.customer => 'Customer' };
  String _formatDate(DateTime? value) => value == null ? 'Không rõ ngày tạo' : '${value.day}/${value.month}/${value.year}';
}

