import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/product_repository.dart';
import 'package:app_bachhoa/services/product_service.dart';
import 'package:app_bachhoa/services/stock_import_repository.dart';
import 'package:flutter/material.dart';

class NhapHangPage extends StatefulWidget {
  const NhapHangPage({super.key});

  @override
  State<NhapHangPage> createState() => _NhapHangPageState();
}

class _NhapHangPageState extends State<NhapHangPage> {
  final ProductRepository _repository = ProductRepository();
  final StockImportRepository _stockImportRepository = StockImportRepository();
  final TextEditingController qtyController = TextEditingController();

  String? selectedCategory;
  Product? selectedProduct;
  List<Product> products = [];
  bool isLoadingProducts = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _repository.ensureSeedProducts();
  }

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  Future<void> _loadProductsByCategory(String categoryId) async {
    setState(() {
      isLoadingProducts = true;
      selectedProduct = null;
      products = [];
    });

    final result = await _repository.getByCategory(categoryId);
    if (!mounted) return;

    setState(() {
      products = result;
      isLoadingProducts = false;
    });
  }

  Future<void> _submitStock() async {
    if (selectedProduct == null || qtyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn sản phẩm và nhập số lượng.')),
      );
      return;
    }

    final qty = int.tryParse(qtyController.text.trim()) ?? 0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số lượng nhập phải lớn hơn 0.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final oldProduct = selectedProduct!;
      final updatedProduct = await _repository.increaseStock(oldProduct.id, qty);
      await _stockImportRepository.add(productId: oldProduct.id, productName: oldProduct.name, quantity: qty, note: 'Nhập kho thủ công');
      final categoryId = selectedCategory;
      final latestProducts = categoryId == null
          ? <Product>[]
          : await _repository.getByCategory(categoryId);

      if (!mounted) return;
      setState(() {
        products = latestProducts;
        selectedProduct = updatedProduct;
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã nhập thêm $qty cho ${updatedProduct.name}.')),
      );
      qtyController.clear();
    } catch (error) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể nhập kho: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ProductService.categories;
    final selectedProductInList = selectedProduct == null
        ? null
        : products.where((p) => p.id == selectedProduct!.id).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập kho'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cập nhật số lượng tồn kho cho sản phẩm',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Chọn danh mục',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      setState(() => selectedCategory = value);
                      if (value != null) _loadProductsByCategory(value);
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Product>(
              initialValue: selectedProductInList,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: isLoadingProducts ? 'Đang tải sản phẩm...' : 'Chọn sản phẩm',
                border: const OutlineInputBorder(),
              ),
              items: products
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        '${p.name} (Tồn: ${p.stock})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) => products
                  .map(
                    (p) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: products.isEmpty || isLoadingProducts || isSaving
                  ? null
                  : (value) => setState(() => selectedProduct = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: qtyController,
              enabled: !isSaving,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số lượng nhập',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.add_box_outlined),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: isSaving ? null : _submitStock,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.inventory_2_outlined),
                label: Text(isSaving ? 'Đang lưu...' : 'Nhập kho'),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedProduct != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_grocery_store_outlined),
                  title: Text(selectedProduct!.name),
                  subtitle: const Text('Tồn kho hiện tại trong database'),
                  trailing: Text(
                    '${selectedProduct!.stock}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

