import 'dart:convert';

import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/models/user_session.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._({
    required SharedPreferences prefs,
    required List<_SeedAccount> seed,
  }) : _prefs = prefs,
       _seed = seed;

  static const _customerKey = 'customer_accounts_v1';

  final SharedPreferences _prefs;
  final List<_SeedAccount> _seed;

  static Future<AuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    final seedText = await rootBundle.loadString('assets/seed_accounts.txt');
    final seed = _parseSeed(seedText);
    return AuthService._(prefs: prefs, seed: seed);
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

    final customers = await _loadCustomers();
    final stored = customers[normalizedUser];
    if (stored != null && stored == normalizedPass) {
      return UserSession(username: normalizedUser, role: UserRole.customer);
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

    final customers = await _loadCustomers();
    if (customers.containsKey(normalized)) {
      return 'Tài khoản này đã tồn tại.';
    }

    customers[normalized] = password;
    await _prefs.setString(_customerKey, jsonEncode(customers));
    return null;
  }

  Future<Map<String, String>> _loadCustomers() async {
    final raw = _prefs.getString(_customerKey);
    if (raw == null || raw.isEmpty) return <String, String>{};

    final decoded = jsonDecode(raw);
    if (decoded is! Map) return <String, String>{};

    return decoded.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
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
