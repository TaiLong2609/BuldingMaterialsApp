import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/widgets/app_scaffold.dart';
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
  bool _isLoading = false;
  final List<Map<String, dynamic>> _backupHistory = [
    {
      'MaSaoLuu': 1,
      'TenFile': 'backup_2026_04_12.db',
      'DuongDanFile': '/backup/backup_2026_04_12.db',
      'DungLuongKB': 2048,
      'LoaiSaoLuu': 'Full',
      'TrangThai': 'Thành công',
      'NgayThucHien': '2026-04-12 10:00:00',
      'MaAdminThucHien': 1,
      'GhiChu': 'Sao lưu định kỳ hàng ngày',
    },
    {
      'MaSaoLuu': 2,
      'TenFile': 'backup_incremental_2026_04_11.db',
      'DuongDanFile': '/backup/backup_incremental_2026_04_11.db',
      'DungLuongKB': 512,
      'LoaiSaoLuu': 'Incremental',
      'TrangThai': 'Thành công',
      'NgayThucHien': '2026-04-11 10:00:00',
      'MaAdminThucHien': 1,
      'GhiChu': 'Sao lưu tăng dần',
    },
    {
      'MaSaoLuu': 3,
      'TenFile': 'backup_manual_2026_04_10.db',
      'DuongDanFile': '/backup/backup_manual_2026_04_10.db',
      'DungLuongKB': 1536,
      'LoaiSaoLuu': 'Full',
      'TrangThai': 'Thất bại',
      'NgayThucHien': '2026-04-10 15:30:00',
      'MaAdminThucHien': 2,
      'GhiChu': 'Sao lưu thủ công trước cập nhật',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      session: widget.session,
      title: 'Back up và Restore Dữ liệu',
      onMenuSelected: widget.onMenuSelected,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Sao lưu và khôi phục dữ liệu',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đảm bảo an toàn dữ liệu của hệ thống bằng cách tạo bản sao lưu định kỳ và khôi phục khi cần thiết.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Backup Actions
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo bản sao lưu',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : () => _createBackup('Full'),
                            icon: const Icon(Icons.backup),
                            label: const Text('Sao lưu đầy đủ'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : () => _createBackup('Incremental'),
                            icon: const Icon(Icons.update),
                            label: const Text('Sao lưu tăng dần'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _configureAutoBackup,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Cấu hình sao lưu tự động'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Backup History
            Text(
              'Lịch sử sao lưu',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _backupHistory.length,
              itemBuilder: (context, index) {
                final backup = _backupHistory[index];
                return _buildBackupItem(context, backup);
              },
            ),

            const SizedBox(height: 24),

            // Restore Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.restore,
                          color: theme.colorScheme.error,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Khôi phục dữ liệu',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                              Text(
                                'Khôi phục dữ liệu từ bản sao lưu. Hành động này sẽ ghi đè dữ liệu hiện tại.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cảnh báo: Việc khôi phục sẽ ghi đè toàn bộ dữ liệu hiện tại. Hãy chắc chắn bạn có bản sao lưu trước khi thực hiện.',
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showRestoreDialog,
                        icon: const Icon(Icons.restore),
                        label: const Text('Khôi phục từ bản sao lưu'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(color: theme.colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Storage Info
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin lưu trữ',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStorageInfo(
                      context,
                      'Tổng dung lượng',
                      '100 GB',
                      '70 GB còn trống',
                      0.3,
                    ),
                    const SizedBox(height: 12),
                    _buildStorageInfo(
                      context,
                      'Bản sao lưu',
                      '15 GB',
                      '85 GB còn lại',
                      0.15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupItem(BuildContext context, Map<String, dynamic> backup) {
    final theme = Theme.of(context);
    final loaiSaoLuu = backup['LoaiSaoLuu'] as String;
    final trangThai = backup['TrangThai'] as String;
    final dungLuongKB = backup['DungLuongKB'] as int;
    final dungLuongMB = (dungLuongKB / 1024).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: loaiSaoLuu == 'Full'
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            loaiSaoLuu == 'Full' ? Icons.backup : Icons.update,
            color: loaiSaoLuu == 'Full'
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
        ),
        title: Text(backup['TenFile']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$dungLuongMB MB • ${backup['NgayThucHien']}'),
            if (backup['GhiChu'] != null && backup['GhiChu'].isNotEmpty)
              Text(
                backup['GhiChu'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trangThai == 'Thành công'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trangThai,
                    style: TextStyle(
                      color: trangThai == 'Thành công' ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: loaiSaoLuu == 'Full'
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loaiSaoLuu,
                    style: TextStyle(
                      color: loaiSaoLuu == 'Full'
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
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
          onSelected: (value) => _handleBackupAction(value, backup),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'download',
              child: Text('Tải xuống'),
            ),
            const PopupMenuItem(
              value: 'restore',
              child: Text('Khôi phục'),
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

  Widget _buildStorageInfo(
    BuildContext context,
    String title,
    String used,
    String available,
    double usageRatio,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$used / $available',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: usageRatio,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(
            usageRatio > 0.8 ? theme.colorScheme.error : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _createBackup(String loaiSaoLuu) async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement backup creation
      await Future.delayed(const Duration(seconds: 3)); // Mock delay

      final now = DateTime.now();
      final typePrefix = loaiSaoLuu == 'Full' ? 'full' : 'incremental';
      final fileName = 'backup_${typePrefix}_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}.db';

      final newBackup = {
        'MaSaoLuu': _backupHistory.length + 1,
        'TenFile': fileName,
        'DuongDanFile': '/backup/$fileName',
        'DungLuongKB': loaiSaoLuu == 'Full' ? 2048 : 512,
        'LoaiSaoLuu': loaiSaoLuu,
        'TrangThai': 'Thành công',
        'NgayThucHien': now.toString(),
        'MaAdminThucHien': 1, // Admin Hệ Thống
        'GhiChu': 'Sao lưu ${loaiSaoLuu.toLowerCase()} thủ công',
      };

      setState(() {
        _backupHistory.insert(0, newBackup);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã tạo bản sao lưu ${loaiSaoLuu.toLowerCase()} thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra khi tạo bản sao lưu')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _configureAutoBackup() {
    // TODO: Implement auto backup configuration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng cấu hình sao lưu tự động đang được phát triển')),
    );
  }

  void _handleBackupAction(String action, Map<String, dynamic> backup) {
    switch (action) {
      case 'download':
        _downloadBackup(backup);
        break;
      case 'restore':
        _restoreFromBackup(backup);
        break;
      case 'delete':
        _deleteBackup(backup);
        break;
    }
  }

  void _downloadBackup(Map<String, dynamic> backup) {
    // TODO: Implement backup download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đang tải xuống ${backup['TenFile']}')),
    );
  }

  void _restoreFromBackup(Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận khôi phục'),
        content: Text(
          'Bạn có chắc muốn khôi phục dữ liệu từ "${backup['TenFile']}"? Dữ liệu hiện tại sẽ bị ghi đè.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement restore
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đang khôi phục từ ${backup['TenFile']}')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Khôi phục'),
          ),
        ],
      ),
    );
  }

  void _deleteBackup(Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa bản sao lưu "${backup['TenFile']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _backupHistory.remove(backup);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa ${backup['TenFile']}')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Khôi phục dữ liệu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chọn bản sao lưu để khôi phục:'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _backupHistory.length,
                itemBuilder: (context, index) {
                  final backup = _backupHistory[index];
                  final dungLuongMB = (backup['DungLuongKB'] / 1024).toStringAsFixed(1);
                  return ListTile(
                    title: Text(backup['TenFile']),
                    subtitle: Text('$dungLuongMB MB • ${backup['NgayThucHien']}'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _restoreFromBackup(backup);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }
}