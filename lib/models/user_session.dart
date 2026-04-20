import 'package:app_bachhoa/models/user_role.dart';

class UserSession {
  const UserSession({required this.username, required this.role});

  final String username;
  final UserRole role;
}
