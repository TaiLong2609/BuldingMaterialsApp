import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<_AddressItem> _addresses = [
    _AddressItem(
      label: 'Nhà riêng',
      address: '12 Lê Văn Sỹ, Phường 12, Quận 3, TP.HCM',
      icon: Icons.home_outlined,
      isPrimary: true,
    ),
    _AddressItem(
      label: 'Cơ quan',
      address: '45 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP.HCM',
      icon: Icons.business_outlined,
      isPrimary: false,
    ),
  ];

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
          'Địa Chỉ Giao Hàng',
          style: GoogleFonts.workSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm địa chỉ',
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? _buildEmpty(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (ctx, i) => _AddressCard(
                item: _addresses[i],
                onSetPrimary: () => setState(() {
                  for (var a in _addresses) {
                    a.isPrimary = false;
                  }
                  _addresses[i].isPrimary = true;
                }),
                onDelete: () => setState(() => _addresses.removeAt(i)),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(
          'Thêm địa chỉ',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 72,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có địa chỉ nào',
            style: GoogleFonts.workSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm địa chỉ nhận hàng của bạn',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final labelCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Thêm địa chỉ mới',
          style: GoogleFonts.workSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên địa chỉ (VD: Nhà riêng)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addrCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ đầy đủ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () {
              if (labelCtrl.text.isNotEmpty && addrCtrl.text.isNotEmpty) {
                setState(() {
                  _addresses.add(_AddressItem(
                    label: labelCtrl.text,
                    address: addrCtrl.text,
                    icon: Icons.location_on_outlined,
                    isPrimary: _addresses.isEmpty,
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class _AddressItem {
  _AddressItem({
    required this.label,
    required this.address,
    required this.icon,
    required this.isPrimary,
  });
  final String label;
  final String address;
  final IconData icon;
  bool isPrimary;
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.item,
    required this.onSetPrimary,
    required this.onDelete,
  });

  final _AddressItem item;
  final VoidCallback onSetPrimary;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: item.isPrimary
            ? Border.all(color: theme.colorScheme.primary, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isPrimary
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 22,
              color: item.isPrimary
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (item.isPrimary) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Mặc định',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.address,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (!item.isPrimary)
                      TextButton.icon(
                        onPressed: onSetPrimary,
                        icon: const Icon(Icons.star_border, size: 14),
                        label: Text(
                          'Đặt mặc định',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 14),
                      label: Text(
                        'Xoá',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
