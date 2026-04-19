import 'package:flutter/material.dart';
import 'package:app_quanlyxaydung/services/product_service.dart';
import 'package:app_quanlyxaydung/services/order_service.dart'; // Thêm import này
import 'package:app_quanlyxaydung/models/product.dart';
import 'package:app_quanlyxaydung/models/cart_item.dart'; // Thêm import này

class BanHangPage extends StatefulWidget {
  const BanHangPage({super.key});

  @override
  State<BanHangPage> createState() => _BanHangPageState();
}

class _BanHangPageState extends State<BanHangPage> {
  final productService = ProductService();
  final orderService = OrderService(); // Khởi tạo Service

  // Thông tin khách hàng
  final _tenKHController = TextEditingController();
  final _sdtController = TextEditingController();
  final _diaChiController = TextEditingController();

  // Chọn sản phẩm tạm thời
  Product? selectedProduct;
  int quantity = 1;

  // Giỏ hàng hiện tại
  List<Map<String, dynamic>> cartItems = [];

  void _addToCart() {
    if (selectedProduct == null) {
      _showMsg("Vui lòng chọn một sản phẩm");
      return;
    }

    setState(() {
      int index = cartItems.indexWhere(
        (item) => (item['product'] as Product).id == selectedProduct!.id,
      );

      if (index >= 0) {
        cartItems[index]['quantity'] += quantity;
      } else {
        cartItems.add({
          'product': selectedProduct,
          'name': selectedProduct!.name,
          'quantity': quantity,
          'price': selectedProduct!.price,
        });
      }
      selectedProduct = null;
      quantity = 1;
    });
  }

  void _checkOut() {
    if (cartItems.isEmpty) {
      _showMsg("Vui lòng thêm sản phẩm vào giỏ hàng");
      return;
    }
    if (_tenKHController.text.isEmpty) {
      _showMsg("Vui lòng nhập tên khách hàng");
      return;
    }

    // 1. Chuyển đổi cartItems (Map) sang List<CartItem> theo đúng Model của OrderService
    List<CartItem> itemsToPlace = cartItems.map((item) {
      return CartItem(
        product: item['product'] as Product,
        quantity: item['quantity'] as int,
      );
    }).toList();

    // 2. Gọi hàm placeOrder từ OrderService (Singleton)
    orderService.placeOrder(
      customerName: _tenKHController.text,
      address: _diaChiController.text.isEmpty
          ? "Không có địa chỉ"
          : _diaChiController.text,
      items: itemsToPlace,
    );

    // 3. Reset giao diện
    setState(() {
      cartItems.clear();
      _tenKHController.clear();
      _sdtController.clear();
      _diaChiController.clear();
    });

    _showMsg("Đã chốt đơn hàng và chuyển sang danh sách Đơn hàng!");

    // Tùy chọn: Tự động quay về sau khi chốt đơn thành công
    // Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final products = productService.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text("Tạo Đơn Hàng Mới"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Thông tin khách hàng"),
            TextField(
              controller: _tenKHController,
              decoration: const InputDecoration(labelText: "Tên khách hàng *"),
            ),
            TextField(
              controller: _sdtController,
              decoration: const InputDecoration(labelText: "Số điện thoại"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _diaChiController,
              decoration: const InputDecoration(labelText: "Địa chỉ giao hàng"),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("Thêm sản phẩm"),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Product>(
                    isExpanded: true,
                    value: selectedProduct,
                    hint: const Text("Chọn sản phẩm"),
                    items: products
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedProduct = val),
                  ),
                ),
                const SizedBox(width: 10),
                _buildQuantityPicker(),
                IconButton(
                  onPressed: _addToCart,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("Giỏ hàng"),
            _buildCartList(),

            const SizedBox(height: 20),
            _buildTotalSection(),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _checkOut,
                child: const Text(
                  "CHỐT ĐƠN & LƯU",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    double total = cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Tổng cộng:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "${total.toInt()} đ",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildQuantityPicker() {
    return Row(
      children: [
        InkWell(
          onTap: () => setState(() => quantity > 1 ? quantity-- : null),
          child: const Icon(Icons.remove_circle_outline),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("$quantity", style: const TextStyle(fontSize: 16)),
        ),
        InkWell(
          onTap: () => setState(() => quantity++),
          child: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildCartList() {
    if (cartItems.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Chưa có sản phẩm nào"),
      );
    return Column(
      children: cartItems.map((item) {
        return Card(
          child: ListTile(
            title: Text(item['name']),
            subtitle: Text("${item['quantity']} x ${item['price']}đ"),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => setState(() => cartItems.remove(item)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
