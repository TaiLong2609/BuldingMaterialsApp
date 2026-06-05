import 'package:app_bachhoa/models/promotion.dart';
import 'package:app_bachhoa/services/promotion_repository.dart';
import 'package:flutter/material.dart';

class QuanLyKhuyenMaiPage extends StatefulWidget {
  const QuanLyKhuyenMaiPage({super.key});

  @override
  State<QuanLyKhuyenMaiPage> createState() => _QuanLyKhuyenMaiPageState();
}

class _QuanLyKhuyenMaiPageState extends State<QuanLyKhuyenMaiPage> {
  final _repo = PromotionRepository();
  List<Promotion> _promotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await _repo.getAll();
    if (!mounted) return;
    setState(() { _promotions = data; _isLoading = false; });
  }

  Future<void> _showForm({Promotion? promotion}) async {
    final titleCtrl = TextEditingController(text: promotion?.title ?? '');
    final codeCtrl = TextEditingController(text: promotion?.code ?? '');
    final descCtrl = TextEditingController(text: promotion?.description ?? '');
    final discountCtrl = TextEditingController(text: promotion?.discountPercent.toString() ?? '');
    var isActive = promotion?.isActive ?? true;
    Promotion? saved;

    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(promotion == null ? 'Thêm mã khuyến mãi' : 'Sửa mã khuyến mãi'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Tiêu đề')),
                  const SizedBox(height: 12),
                  TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Mã khuyến mãi')),
                  const SizedBox(height: 12),
                  TextField(controller: discountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giảm giá (%)')),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Mô tả')),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: isActive,
                    onChanged: (value) => setDialogState(() => isActive = value),
                    title: const Text('Đang áp dụng'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Huỷ')),
              FilledButton(
                onPressed: () {
                  final title = titleCtrl.text.trim();
                  final code = codeCtrl.text.trim().toUpperCase();
                  final discount = double.tryParse(discountCtrl.text.trim()) ?? 0;
                  if (title.isEmpty || code.isEmpty || discount <= 0) return;
                  saved = Promotion(
                    id: promotion?.id,
                    title: title,
                    code: code,
                    description: descCtrl.text.trim(),
                    discountPercent: discount,
                    isActive: isActive,
                    createdAt: promotion?.createdAt ?? DateTime.now(),
                  );
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      );
      if (ok != true || saved == null) return;
      await _repo.upsert(saved!);
      await _load();
    } finally {
      titleCtrl.dispose();
      codeCtrl.dispose();
      descCtrl.dispose();
      discountCtrl.dispose();
    }
  }

  Future<void> _delete(Promotion promotion) async {
    if (promotion.id == null) return;
    await _repo.delete(promotion.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý khuyến mãi'),
        actions: [IconButton(onPressed: () => _showForm(), icon: const Icon(Icons.add))],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _promotions.isEmpty
                  ? ListView(children: const [SizedBox(height: 220), Center(child: Text('Chưa có mã khuyến mãi.'))])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _promotions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final promo = _promotions[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: promo.isActive ? Colors.green.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                              child: Icon(Icons.local_offer_outlined, color: promo.isActive ? Colors.green : Colors.grey),
                            ),
                            title: Text('${promo.title} • ${promo.code}'),
                            subtitle: Text('Giảm ${promo.discountPercent.toStringAsFixed(0)}% • ${promo.isActive ? 'Đang áp dụng' : 'Đã tắt'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () => _showForm(promotion: promo), icon: const Icon(Icons.edit_outlined)),
                                IconButton(onPressed: () => _delete(promo), icon: const Icon(Icons.delete_outline, color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm mã'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

