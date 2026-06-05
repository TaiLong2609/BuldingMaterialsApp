import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/product_repository.dart';
import 'package:app_bachhoa/services/product_service.dart';
import 'package:flutter/material.dart';

class QuanLyVatLieuPage extends StatefulWidget {
  const QuanLyVatLieuPage({super.key, this.onExit});

  final VoidCallback? onExit;

  @override
  State<QuanLyVatLieuPage> createState() => _QuanLyVatLieuPageState();
}

class _QuanLyVatLieuPageState extends State<QuanLyVatLieuPage> {
  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchCtrl = TextEditingController();

  List<Product> products = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
    _loadProducts();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
          product.category.toLowerCase().contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery);
    }).toList();
  }

  String _categoryName(String categoryId) {
    for (final category in ProductService.categories) {
      if (category.id == categoryId) return category.name;
    }
    return categoryId;
  }

  Future<void> _loadProducts() async {
    setState(() => isLoading = true);
    final result = await _repository.getAll();
    if (!mounted) return;
    setState(() {
      products = result;
      isLoading = false;
    });
  }

  Future<void> _delete(Product product) async {
    await _repository.delete(product.id);
    await _loadProducts();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá ${product.name}.')),
    );
  }

  Future<void> _showForm({Product? product}) async {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl = TextEditingController(text: product?.stock.toString() ?? '');
    final unitCtrl = TextEditingController(text: product?.unit ?? 'món');
    final descriptionCtrl = TextEditingController(text: product?.description ?? '');
    String selectedCategory = product?.category ?? ProductService.categories.first.id;

    Product? productToSave;

    try {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Danh mục'),
                        items: ProductService.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,
                                child: Text(
                                  category.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() => selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Giá bán'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: stockCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Tồn kho'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: unitCtrl,
                        decoration: const InputDecoration(labelText: 'Đơn vị'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Mô tả'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Huỷ'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Tên sản phẩm không được để trống.')),
                        );
                        return;
                      }

                      final unitText = unitCtrl.text.trim();
                      productToSave = Product(
                        id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        category: selectedCategory,
                        price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                        unit: unitText.isEmpty ? 'món' : unitText,
                        stock: int.tryParse(stockCtrl.text.trim()) ?? 0,
                        description: descriptionCtrl.text.trim(),
                        specs: product?.specs ?? const [],
                        imageIcon: product?.imageIcon,
                      );

                      Navigator.of(dialogContext).pop(true);
                    },
                    child: const Text('Lưu'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (shouldSave != true || productToSave == null) return;

      await _repository.upsert(productToSave!);
      await _loadProducts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu ${productToSave!.name}.')),
      );
    } finally {
      nameCtrl.dispose();
      priceCtrl.dispose();
      stockCtrl.dispose();
      unitCtrl.dispose();
      descriptionCtrl.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleProducts = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Thoát',
          onPressed: () {
            if (widget.onExit != null) {
              widget.onExit!();
              return;
            }
            Navigator.maybePop(context);
          },
        ),
        title: const Text('Quản lý sản phẩm'),
        actions: [
          IconButton(onPressed: () => _showForm(), icon: const Icon(Icons.add)),
          IconButton(onPressed: _loadProducts, icon: const Icon(Icons.refresh)),
          TextButton.icon(
            onPressed: () {
              if (widget.onExit != null) {
                widget.onExit!();
              } else {
                Navigator.maybePop(context);
              }
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            label: const Text('Thoát', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _searchCtrl.clear,
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text('Chưa có sản phẩm trong database.'))
                    : visibleProducts.isEmpty
                        ? const Center(child: Text('Không tìm thấy sản phẩm phù hợp.'))
                        : RefreshIndicator(
                            onRefresh: _loadProducts,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              itemCount: visibleProducts.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final product = visibleProducts[index];

                                return Card(
                                  elevation: 2,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                      child: Icon(
                                        Icons.local_grocery_store_outlined,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    title: Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      '${_categoryName(product.category)} • Tồn kho: ${product.stock} • Giá: ${product.formattedPrice}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () => _showForm(product: product),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () => _delete(product),
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

