import 'package:flutter/material.dart';
import 'package:app_bachhoa/services/product_service.dart';
import 'package:app_bachhoa/models/product.dart';

class NhapHangPage extends StatefulWidget {
  const NhapHangPage({super.key});

  @override
  State<NhapHangPage> createState() => _NhapHangPageState();
}

class _NhapHangPageState extends State<NhapHangPage> {
  final ProductService _service = ProductService();

  String? selectedCategory;
  Product? selectedProduct;

  final TextEditingController qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categories = ProductService.categories;

    final products = selectedCategory == null
        ? <Product>[]
        : _service.getByCategory(selectedCategory!);

    return Scaffold(
      appBar: AppBar(title: const Text("Nhập hàng"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ───────── DANH MỤC ─────────
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Chọn danh mục",
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: categories.map((c) {
                return DropdownMenuItem(value: c.id, child: Text(c.name));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  selectedProduct = null;
                });
              },
            ),

            const SizedBox(height: 16),

            // ───────── SẢN PHẨM ─────────
            DropdownButtonFormField<Product>(
              decoration: const InputDecoration(
                labelText: "Chọn sản phẩm",
                border: OutlineInputBorder(),
              ),
              value: selectedProduct,
              items: products.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text("${p.name} (Tồn: ${p.stock})"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // ───────── SỐ LƯỢNG ─────────
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số lượng nhập",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ───────── BUTTON ─────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedProduct == null || qtyController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thiếu dữ liệu")),
                    );
                    return;
                  }

                  final qty = int.tryParse(qtyController.text) ?? 0;

                  if (qty <= 0) return;

                  // 🔥 FAKE UPDATE (chỉ UI)
                  setState(() {
                    selectedProduct = selectedProduct!.copyWith(
                      stock: selectedProduct!.stock + qty,
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Đã nhập +$qty cho ${selectedProduct!.name}",
                      ),
                    ),
                  );

                  qtyController.clear();
                },
                child: const Text("Nhập hàng"),
              ),
            ),

            const SizedBox(height: 20),

            // ───────── PREVIEW ─────────
            if (selectedProduct != null)
              Card(
                child: ListTile(
                  title: Text(selectedProduct!.name),
                  subtitle: Text("Tồn kho hiện tại"),
                  trailing: Text(
                    "${selectedProduct!.stock}",
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
