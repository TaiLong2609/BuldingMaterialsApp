import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/login_page.dart';
import 'package:app_quanlyxaydung/screens/placeholder_page.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.authService});

  final AuthService authService;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  UserSession? _session;

  void _onLoggedIn(UserSession session) {
    setState(() {
      _session = session;
    });
  }

  void _logout() {
    setState(() {
      _session = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );

    return MaterialApp(
      title: 'VLXD',
      theme: theme,
      home: _session == null
          ? LoginPage(authService: widget.authService, onLoggedIn: _onLoggedIn)
          : PlaceholderPage(
              session: _session!,
              title: 'Trang chủ',
              onLogout: _logout,
            ),
    );
  }
}
