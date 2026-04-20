import 'package:app_bachhoa/models/user_session.dart';
import 'package:app_bachhoa/models/user_role.dart';
import 'package:app_bachhoa/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ManagerProfilePage extends StatefulWidget {
  final UserSession session;
  final ValueChanged<String>? onMenuSelected;

  const ManagerProfilePage({
    super.key,
    required this.session,
    this.onMenuSelected,
  });

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // 🔥 GIỐNG ADMIN: vẫn mock data, không phá session
  void _loadUserData() {
    _usernameController.text = widget.session.username;

    // giống Admin style (không có backend thì để mock nhẹ)
    _fullNameController.text = "Quản lý kho";
    _phoneController.text = "0909 123 456";
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      session: widget.session,
      title: 'Hồ sơ quản lý',
      onMenuSelected: widget.onMenuSelected ?? (_) {},
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [_buildHeader(), const SizedBox(height: 20), _buildForm()],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            _usernameController.text.isNotEmpty
                ? _usernameController.text[0].toUpperCase()
                : "?",
          ),
        ),
        title: Text(_fullNameController.text),
        subtitle: Text("Vai trò: ${widget.session.role.name}"),
      ),
    );
  }

  // ================= FORM =================
  Widget _buildForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_usernameController, "Tên đăng nhập", false),
              const SizedBox(height: 12),
              _field(_fullNameController, "Họ tên", _isEditing),
              const SizedBox(height: 12),
              _field(_phoneController, "Số điện thoại", _isEditing),
              const SizedBox(height: 20),

              _isEditing ? _actions() : _editButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, bool enabled) {
    return TextFormField(
      controller: c,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // ================= BUTTON =================
  Widget _editButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => setState(() => _isEditing = true),
        child: const Text("Chỉnh sửa"),
      ),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
                _loadUserData(); // reset giống admin
              });
            },
            child: const Text("Hủy"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _save,
            child: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Lưu"),
          ),
        ),
      ],
    );
  }

  // ================= SAVE =================
  void _save() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
  }
}
