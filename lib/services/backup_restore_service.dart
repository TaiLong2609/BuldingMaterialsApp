import 'dart:io';

import 'package:app_bachhoa/services/database_service.dart';
import 'package:path/path.dart' as p;

class BackupFileInfo {
  const BackupFileInfo({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.createdAt,
  });

  final String name;
  final String path;
  final int sizeBytes;
  final DateTime createdAt;

  double get sizeMb => sizeBytes / 1024 / 1024;
}

class BackupRestoreService {
  BackupRestoreService({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<List<BackupFileInfo>> listBackups() async {
    final dir = Directory(await _databaseService.getBackupDirectoryPath());
    if (!await dir.exists()) return [];

    final files = await dir
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.db'))
        .cast<File>()
        .toList();

    final result = <BackupFileInfo>[];
    for (final file in files) {
      final stat = await file.stat();
      result.add(
        BackupFileInfo(
          name: p.basename(file.path),
          path: file.path,
          sizeBytes: stat.size,
          createdAt: stat.modified,
        ),
      );
    }

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  Future<BackupFileInfo> createBackup() async {
    // Đảm bảo DB đã được tạo trước khi copy file.
    await _databaseService.database;

    final sourcePath = await _databaseService.getDatabaseFilePath();
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw StateError('Không tìm thấy file database để sao lưu.');
    }

    final backupDir = Directory(await _databaseService.getBackupDirectoryPath());
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final now = DateTime.now();
    final stamp = _timestamp(now);
    final backupPath = p.join(backupDir.path, 'backup_$stamp.db');
    final backupFile = await sourceFile.copy(backupPath);
    final stat = await backupFile.stat();

    return BackupFileInfo(
      name: p.basename(backupPath),
      path: backupPath,
      sizeBytes: stat.size,
      createdAt: stat.modified,
    );
  }

  Future<void> restoreBackup(String backupPath) async {
    final backupFile = File(backupPath);
    if (!await backupFile.exists()) {
      throw StateError('File sao lưu không tồn tại.');
    }

    final databasePath = await _databaseService.getDatabaseFilePath();
    await _databaseService.close();
    await backupFile.copy(databasePath);
  }

  Future<void> deleteBackup(String backupPath) async {
    final file = File(backupPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _timestamp(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}${two(value.month)}${two(value.day)}_${two(value.hour)}${two(value.minute)}${two(value.second)}';
  }
}
