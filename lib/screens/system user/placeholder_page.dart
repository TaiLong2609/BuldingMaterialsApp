import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.session,
    required this.title,
    required this.onLogout,
  });

  final UserSession session;
  final String title;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      session: session,
      title: title,
      onMenuSelected: (item) {
        if (item == 'Đăng xuất') {
          Navigator.of(context).popUntil((route) => route.isFirst);
          onLogout();
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlaceholderPage(
              session: session,
              title: item,
              onLogout: onLogout,
            ),
          ),
        );
      },
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
