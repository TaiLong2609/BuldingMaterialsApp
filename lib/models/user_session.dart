import 'package:app_quanlyxaydung/models/user_role.dart';

class UserSession {
  const UserSession({required this.username, required this.role});

  final String username;
  final UserRole role;
}
