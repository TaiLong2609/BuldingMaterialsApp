import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/screens/login_page.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';
import 'package:app_quanlyxaydung/services/cart_service.dart';
import 'package:app_quanlyxaydung/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    // ── Industrial Sophistication Theme ──────────────────────────
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A237E),
      brightness: Brightness.light,
      primary: const Color(0xFF000666),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF1A237E),
      secondary: const Color(0xFF8F4E00),
      secondaryContainer: const Color(0xFFFF8F00),
      onSecondaryContainer: const Color(0xFF623400),
      surface: const Color(0xFFF9F9F9),
      surfaceContainerLow: const Color(0xFFF3F3F3),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerHighest: const Color(0xFFE2E2E2),
      onSurface: const Color(0xFF1A1C1C),
      onSurfaceVariant: const Color(0xFF454652),
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.workSans(
          fontSize: 57,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.workSans(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.workSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: GoogleFonts.workSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.workSans(
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.workSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF000666),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.workSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF000666),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF9F9F9),
        indicatorColor: const Color(0xFF1A237E).withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF000666), width: 2),
        ),
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => CartService(),
      child: MaterialApp(
        title: 'VLXD',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: _session == null
            ? LoginPage(
                authService: widget.authService,
                onLoggedIn: _onLoggedIn,
              )
            : AppBottomNav(
                session: _session!,
                onLogout: _logout,
              ),
      ),
    );
  }
}
