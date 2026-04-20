import 'package:app_bachhoa/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.authService});

  final AuthService authService;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _showPass = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final error = await widget.authService.registerCustomer(
        phone: _phoneCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), behavior: SnackBarBehavior.floating),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(' Đăng ký thành công! Bạn có thể đăng nhập.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green[700],
        ),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tạo tài khoản',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đăng ký để mua sắm vật liệu xây dựng',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 0,
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Thông tin đăng ký',
                            style: GoogleFonts.workSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Phone
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Số điện thoại',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              labelStyle: GoogleFonts.inter(fontSize: 14),
                            ),
                            validator: (v) {
                              final val = (v ?? '').trim();
                              if (val.isEmpty) {
                                return 'Nhập số điện thoại';
                              }
                              if (val.length < 9) {
                                return 'Số điện thoại không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: !_showPass,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_showPass
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () =>
                                    setState(() => _showPass = !_showPass),
                              ),
                              labelStyle: GoogleFonts.inter(fontSize: 14),
                            ),
                            validator: (v) {
                              if ((v ?? '').length < 6) {
                                return 'Mật khẩu ít nhất 6 ký tự';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm password
                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              prefixIcon:
                                  const Icon(Icons.lock_person_outlined),
                              labelStyle: GoogleFonts.inter(fontSize: 14),
                            ),
                            validator: (v) {
                              if (v != _passCtrl.text) {
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: _isSubmitting ? null : _submit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Đăng Ký',
                                      style: GoogleFonts.workSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đã có tài khoản? ',
                                style: GoogleFonts.inter(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Đăng nhập',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
