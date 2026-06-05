import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/services/backup_restore_service.dart';
import 'package:app_bachhoa/services/activity_log_repository.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AdminBackupRestorePage extends StatefulWidget {
  const AdminBackupRestorePage({
    super.key,
    required this.session,
    required this.onMenuSelected,
  });

  final UserSession session;
  final ValueChanged<String> onMenuSelected;

  @override
  State<AdminBackupRestorePage> createState() => _AdminBackupRestorePageState();
}

class _AdminBackupRestorePageState extends State<AdminBackupRestorePage> {
  final BackupRestoreService _service = BackupRestoreService();
  final ActivityLogRepository _logRepo = ActivityLogRepository();
  List<BackupFileInfo> _backups = [];
  bool _isLoading = true;
  bool _isWorking = false;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    setState(() => _isLoading = true);
    final backups = await _service.listBackups();
    if (!mounted) return;
    setState(() {
      _backups = backups;
      _isLoading = false;
    });
  }

  Future<void> _createBackup() async {
    setState(() => _isWorking = true);
    try {
      final backup = await _service.createBackup();
      await _logRepo.add(actor: widget.session.username, action: 'Sao lưu dữ liệu', detail: 'Tạo bản sao lưu ');
      await _loadBackups();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tạo bản sao lưu ${backup.name}')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể sao lưu: $error')),
      );
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _restoreBackup(BackupFileInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận khôi phục'),
        content: Text(
          'Bạn có chắc muốn khôi phục từ "${backup.name}"?\n\nDữ liệu hiện tại sẽ bị ghi đè bằng bản sao lưu này.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Khôi phục'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isWorking = true);
    try {
      await _service.restoreBackup(backup.path);
      await _logRepo.add(actor: widget.session.username, action: 'Khôi phục dữ liệu', detail: 'Khôi phục từ ');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Khôi phục thành công. Hãy chuyển trang hoặc khởi động lại app để tải lại dữ liệu.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể khôi phục: $error')),
      );
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _deleteBackup(BackupFileInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoá bản sao lưu'),
        content: Text('Bạn có chắc muốn xoá "${backup.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _service.deleteBackup(backup.path);
    await _logRepo.add(actor: widget.session.username, action: 'Xoá bản sao lưu', detail: 'Xoá ');
    await _loadBackups();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá ${backup.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      session: widget.session,
      title: 'Sao lưu & khôi phục',
      onMenuSelected: widget.onMenuSelected,
      body: RefreshIndicator(
        onRefresh: _loadBackups,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Sao lưu và khôi phục dữ liệu',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo bản sao file SQLite của app để bảo vệ dữ liệu tài khoản, sản phẩm, đơn hàng và doanh thu.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.backup_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tạo bản sao lưu hiện tại',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Bản sao lưu sẽ được lưu trong thư mục database của ứng dụng.'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isWorking ? null : _createBackup,
                        icon: _isWorking
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(_isWorking ? 'Đang xử lý...' : 'Sao lưu ngay'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_outlined, color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Khôi phục sẽ ghi đè database hiện tại. Nên tạo bản sao lưu mới trước khi khôi phục.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách bản sao lưu',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _loadBackups,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_backups.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Chưa có bản sao lưu nào.')),
                ),
              )
            else
              for (final backup in _backups) _BackupTile(
                backup: backup,
                onRestore: _isWorking ? null : () => _restoreBackup(backup),
                onDelete: _isWorking ? null : () => _deleteBackup(backup),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  final BackupFileInfo backup;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.storage_outlined, color: theme.colorScheme.primary),
        ),
        title: Text(backup.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${backup.sizeMb.toStringAsFixed(2)} MB • ${_formatDate(backup.createdAt)}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'restore') onRestore?.call();
            if (value == 'delete') onDelete?.call();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'restore', child: Text('Khôi phục')),
            PopupMenuItem(value: 'delete', child: Text('Xoá')),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year} ${two(value.hour)}:${two(value.minute)}';
  }
}

