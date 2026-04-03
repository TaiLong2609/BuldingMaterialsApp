import 'package:flutter/material.dart';

import 'package:app_quanlyxaydung/app/app_root.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.create();
  runApp(AppRoot(authService: authService));
}
