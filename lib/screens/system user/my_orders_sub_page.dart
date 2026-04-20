import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/screens/system user/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrdersSubPage extends StatelessWidget {
  const MyOrdersSubPage({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Quay lại',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Lịch Sử Đơn Hàng',
          style: GoogleFonts.workSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: OrdersPage(session: session, onLogout: onLogout),
    );
  }
}
