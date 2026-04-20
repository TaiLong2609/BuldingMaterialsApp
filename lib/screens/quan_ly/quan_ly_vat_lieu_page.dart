import 'package:flutter/material.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/product_service.dart';

class QuanLyVatLieuPage extends StatefulWidget {
  const QuanLyVatLieuPage({super.key});

  @override
  State<QuanLyVatLieuPage> createState() => _QuanLyVatLieuPageState();
}

class _QuanLyVatLieuPageState extends State<QuanLyVatLieuPage> {
  final productService = ProductService();

  late List<Product> products;

  @override
  void initState() {
    super.initState();
    products = List.from(productService.getAll()); // copy ra để fake
  }

  void _delete(Product p) {
    setState(() {
      products.removeWhere((e) => e.id == p.id);
    });
  }

  void _showForm({Product? product}) {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final priceCtrl = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final stockCtrl = TextEditingController(
      text: product?.stock.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Thêm vật liệu" : "Sửa vật liệu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tên"),
            ),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Giá"),
            ),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Số lượng"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                id: product?.id ?? DateTime.now().toString(),
                name: nameCtrl.text,
                category: product?.category ?? 'khac',
                price: double.tryParse(priceCtrl.text) ?? 0,
                unit: product?.unit ?? 'cái',
                stock: int.tryParse(stockCtrl.text) ?? 0,
                description: product?.description ?? '',
              );

              setState(() {
                if (product == null) {
                  products.add(newProduct);
                } else {
                  final index = products.indexWhere((e) => e.id == product.id);
                  products[index] = newProduct;
                }
              });

              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý vật liệu"),
        actions: [
          IconButton(onPressed: () => _showForm(), icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];

          return Card(
            child: ListTile(
              title: Text(p.name),
              subtitle: Text("SL: ${p.stock} | ${p.price}đ"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(product: p),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _delete(p),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
