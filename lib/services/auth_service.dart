import 'dart:convert';

import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:app_bachhoa/services/user_repository.dart';

class AuthService {
  AuthService._({
    required UserRepository userRepository,
    required List<_SeedAccount> seed,
  }) : _userRepository = userRepository,
       _seed = seed;

  final UserRepository _userRepository;
  final List<_SeedAccount> _seed;

  static Future<AuthService> create() async {
    final seedText = await rootBundle.loadString('assets/seed_accounts.txt');
    final seed = _parseSeed(seedText);
    return AuthService._(userRepository: UserRepository(), seed: seed);
  }

  Future<UserSession?> login({
    required String username,
    required String password,
  }) async {
    final normalizedUser = username.trim();
    final normalizedPass = password;

    for (final account in _seed) {
      if (account.username == normalizedUser &&
          account.password == normalizedPass) {
        return UserSession(username: normalizedUser, role: account.role);
      }
    }

    final stored = await _userRepository.findByUsername(normalizedUser);
    if (stored != null && stored.password == normalizedPass) {
      return UserSession(username: normalizedUser, role: stored.role);
    }

    return null;
  }

  Future<String?> registerCustomer({
    required String phone,
    required String password,
  }) async {
    final normalized = phone.trim();
    if (normalized.isEmpty) return 'Số điện thoại không được để trống.';
    if (password.isEmpty) return 'Mật khẩu không được để trống.';

    if (_seed.any((a) => a.username == normalized)) {
      return 'Tài khoản này đã tồn tại.';
    }

    if (await _userRepository.exists(normalized)) {
      return 'Tài khoản này đã tồn tại.';
    }

    await _userRepository.insertUser(
      username: normalized,
      password: password,
      role: UserRole.customer,
    );
    return null;
  }

  static List<_SeedAccount> _parseSeed(String text) {
    final lines = const LineSplitter().convert(text);
    final result = <_SeedAccount>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.startsWith('#')) continue;

      final parts = trimmed.split('|');
      if (parts.length < 3) continue;

      final username = parts[0].trim();
      final password = parts[1];
      final roleRaw = parts[2].trim().toUpperCase();

      final role = switch (roleRaw) {
        'ADMIN' => UserRole.admin,
        'MANAGER' => UserRole.manager,
        'CUSTOMER' => UserRole.customer,
        _ => null,
      };

      if (role == null || username.isEmpty) continue;

      result.add(
        _SeedAccount(username: username, password: password, role: role),
      );
    }

    return result;
  }
}

class _SeedAccount {
  const _SeedAccount({
    required this.username,
    required this.password,
    required this.role,
  });

  final String username;
  final String password;
  final UserRole role;
}

