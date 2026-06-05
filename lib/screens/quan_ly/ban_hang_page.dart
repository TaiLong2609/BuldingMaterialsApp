import 'package:app_bachhoa/models/cart_item.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:app_bachhoa/services/order_repository.dart';
import 'package:app_bachhoa/services/order_service.dart';
import 'package:app_bachhoa/services/product_repository.dart';
import 'package:app_bachhoa/screens/system user/location_picker_page.dart';
import 'package:flutter/material.dart';

class BanHangPage extends StatefulWidget {
  const BanHangPage({super.key});

  @override
  State<BanHangPage> createState() => _BanHangPageState();
}

class _BanHangPageState extends State<BanHangPage> {
  final _productRepository = ProductRepository();
  final _orderRepository = OrderRepository();
  final _orderService = OrderService();

  final _tenKHController = TextEditingController();
  final _sdtController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _searchController = TextEditingController();

  List<Product> _products = [];
  List<Product> _searchResults = [];
  final List<CartItem> _cartItems = [];
  Product? selectedProduct;
  int quantity = 1;
  bool _isLoadingProducts = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _tenKHController.dispose();
    _sdtController.dispose();
    _diaChiController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final products = await _productRepository.getAll();
    if (!mounted) return;
    setState(() {
      _products = products;
      _isLoadingProducts = false;
    });
  }

  void _onSearchProduct(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _searchResults = [];
        return;
      }
      _searchResults = _products
          .where((product) =>
              product.name.toLowerCase().contains(q) ||
              product.category.toLowerCase().contains(q))
          .take(8)
          .toList();
    });
  }

  void _selectProduct(Product product) {
    setState(() {
      selectedProduct = product;
      _searchController.text = product.name;
      _searchResults = [];
    });
  }

  void _addToCart() {
    if (selectedProduct == null) {
      _showMsg('Vui lòng tìm và chọn một sản phẩm.');
      return;
    }
    if (quantity <= 0) return;

    setState(() {
      final index = _cartItems.indexWhere((item) => item.product.id == selectedProduct!.id);
      if (index >= 0) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(product: selectedProduct!, quantity: quantity));
      }
      selectedProduct = null;
      quantity = 1;
      _searchController.clear();
      _searchResults = [];
    });
  }

  Future<void> _checkOut() async {
    if (_cartItems.isEmpty) {
      _showMsg('Vui lòng thêm sản phẩm vào giỏ hàng.');
      return;
    }
    if (_tenKHController.text.trim().isEmpty) {
      _showMsg('Vui lòng nhập tên khách hàng.');
      return;
    }

    final address = _diaChiController.text.trim().isEmpty
        ? 'Không có địa chỉ'
        : _diaChiController.text.trim();

    setState(() => _isSaving = true);
    try {
      await _orderRepository.placeOrder(
        customerName: _tenKHController.text.trim(),
        address: address,
        items: _cartItems.map((e) => CartItem(product: e.product, quantity: e.quantity)).toList(),
      );

      _orderService.placeOrder(
        customerName: _tenKHController.text.trim(),
        address: address,
        items: _cartItems.map((e) => CartItem(product: e.product, quantity: e.quantity)).toList(),
      );

      setState(() {
        _cartItems.clear();
        _tenKHController.clear();
        _sdtController.clear();
        _diaChiController.clear();
      });
      await _loadProducts();
      _showMsg('Đã chốt đơn hàng và lưu vào database.');
    } catch (error) {
      _showMsg('Không thể chốt đơn: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo đơn hàng mới'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Thông tin khách hàng'),
            TextField(
              controller: _tenKHController,
              decoration: const InputDecoration(labelText: 'Tên khách hàng *'),
            ),
            TextField(
              controller: _sdtController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _diaChiController,
              decoration: const InputDecoration(labelText: 'Địa chỉ giao hàng'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await Navigator.push<PickedLocation>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPickerPage(initialAddress: _diaChiController.text),
                  ),
                );
                if (picked != null) _diaChiController.text = picked.address;
              },
              icon: const Icon(Icons.map_outlined),
              label: const Text('Chọn địa điểm trên bản đồ'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Tìm và thêm sản phẩm'),
            TextField(
              controller: _searchController,
              enabled: !_isLoadingProducts,
              onChanged: _onSearchProduct,
              decoration: InputDecoration(
                labelText: _isLoadingProducts ? 'Đang tải sản phẩm...' : 'Tìm sản phẩm theo tên',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchResults = [];
                            selectedProduct = null;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            if (_searchResults.isNotEmpty)
              Card(
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  children: _searchResults
                      .map(
                        (product) => ListTile(
                          leading: const Icon(Icons.local_grocery_store_outlined),
                          title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text('Tồn: ${product.stock} • ${product.formattedPrice}'),
                          onTap: () => _selectProduct(product),
                        ),
                      )
                      .toList(),
                ),
              ),
            if (selectedProduct != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Card(
                  child: ListTile(
                    title: Text(selectedProduct!.name),
                    subtitle: Text('Đã chọn • Tồn: ${selectedProduct!.stock}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQuantityPicker(),
                        IconButton(
                          onPressed: _addToCart,
                          icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('Giỏ hàng'),
            _buildCartList(),
            const SizedBox(height: 20),
            _buildTotalSection(),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isSaving ? null : _checkOut,
                child: Text(_isSaving ? 'Đang lưu...' : 'CHỐT ĐƠN & LƯU'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    final total = _cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('${total.toInt()} đ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildQuantityPicker() {
    return Row(
      children: [
        InkWell(onTap: () => setState(() => quantity > 1 ? quantity-- : null), child: const Icon(Icons.remove_circle_outline)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$quantity', style: const TextStyle(fontSize: 16))),
        InkWell(onTap: () => setState(() => quantity++), child: const Icon(Icons.add_circle_outline)),
      ],
    );
  }

  Widget _buildCartList() {
    if (_cartItems.isEmpty) {
      return const Padding(padding: EdgeInsets.all(8), child: Text('Chưa có sản phẩm nào'));
    }
    return Column(
      children: _cartItems.map((item) {
        return Card(
          child: ListTile(
            title: Text(item.product.name),
            subtitle: Text('${item.quantity} x ${item.product.formattedPrice}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => setState(() => _cartItems.remove(item)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

