import 'package:app_quanlyxaydung/models/user_session.dart';
import 'package:app_quanlyxaydung/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.authService,
    required this.onLoggedIn,
  });

  final AuthService authService;
  final ValueChanged<UserSession> onLoggedIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegister = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      if (_isRegister) {
        final error = await widget.authService.registerCustomer(
          phone: username,
          password: password,
        );
        if (!mounted) return;

        if (error != null) {
          messenger.showSnackBar(SnackBar(content: Text(error)));
          return;
        }

        messenger.showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công. Bạn có thể đăng nhập.'),
          ),
        );
        setState(() {
          _isRegister = false;
        });
        return;
      }

      final session = await widget.authService.login(
        username: username,
        password: password,
      );
      if (!mounted) return;

      if (session == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu.')),
        );
        return;
      }

      widget.onLoggedIn(session);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegister = !_isRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final child = isWide ? _buildWide(context) : _buildNarrow(context);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWide(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildLeftPanel(context)),
        Expanded(child: _buildRightPanel(context)),
      ],
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 260, child: _buildLeftPanel(context)),
        _buildRightPanel(context),
      ],
    );
  }

  Widget _buildLeftPanel(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/BackGroundLogin.png', fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.65),
                theme.colorScheme.tertiary.withValues(alpha: 0.25),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VLXD',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Khám phá vật liệu xây dựng bạn cần.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đăng nhập để tiếp tục.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    final theme = Theme.of(context);

    final title = _isRegister ? 'Tạo tài khoản mới' : 'Đăng nhập';
    final hintUser = _isRegister ? 'Số điện thoại' : 'Email hoặc số di động';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: _isRegister
                          ? TextInputType.phone
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: hintUser,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Vui lòng nhập tài khoản.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Vui lòng nhập mật khẩu.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: Text(_isRegister ? 'Đăng ký' : 'Đăng nhập'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isSubmitting ? null : _toggleMode,
                      child: Text(
                        _isRegister
                            ? 'Quay lại đăng nhập'
                            : 'Tạo tài khoản mới',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tài khoản demo:\n- Admin: admin / admin123\n- Quản lý: quanly / ql123',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
