import 'package:flutter/material.dart';

import 'package:app_bachhoa/app/app_root.dart';
import 'package:app_bachhoa/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.create();
  runApp(AppRoot(authService: authService));
}
