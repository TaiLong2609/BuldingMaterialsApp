import 'package:app_bachhoa/models/category.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:flutter/material.dart';

class ProductService {
  static final List<Category> categories = const [
    Category(
      id: 'rau-cu',
      name: 'Rau Củ',
      icon: Icons.eco_outlined,
      productCount: 12,
      color: Color(0xFF388E3C),
    ),
    Category(
      id: 'thit-ca',
      name: 'Thịt & Hải Sản',
      icon: Icons.set_meal_outlined,
      productCount: 10,
      color: Color(0xFFD32F2F),
    ),
    Category(
      id: 'do-kho',
      name: 'Đồ Khô & Gia Vị',
      icon: Icons.inventory_2_outlined,
      productCount: 8,
      color: Color(0xFF795548),
    ),
    Category(
      id: 'sua-trung',
      name: 'Sữa & Trứng',
      icon: Icons.egg_outlined,
      productCount: 9,
      color: Color(0xFFFFA000),
    ),
    Category(
      id: 'banh-keo',
      name: 'Bánh & Kẹo',
      icon: Icons.bakery_dining_outlined,
      productCount: 11,
      color: Color(0xFFE91E63),
    ),
    Category(
      id: 'do-uong',
      name: 'Đồ Uống',
      icon: Icons.local_drink_outlined,
      productCount: 9,
      color: Color(0xFF0288D1),
    ),
    Category(
      id: 'dong-lanh',
      name: 'Đông Lạnh',
      icon: Icons.ac_unit_outlined,
      productCount: 7,
      color: Color(0xFF00838F),
    ),
    Category(
      id: 'che-bien',
      name: 'Thực Phẩm Chế Biến',
      icon: Icons.restaurant_outlined,
      productCount: 8,
      color: Color(0xFFE65100),
    ),
  ];

  static final List<Product> _products = [
    // Rau Củ
    const Product(
      id: 'rc-001',
      name: 'Rau Muống Hữu Cơ',
      category: 'rau-cu',
      price: 12000,
      unit: 'bó 300g',
      stock: 200,
      description:
          'Rau muống hữu cơ trồng theo tiêu chuẩn VietGAP, không thuốc trừ sâu, tươi sạch thu hoạch mỗi sáng.',
      specs: ['Hữu cơ', 'VietGAP', 'Tươi hàng ngày', 'Không hóa chất'],
    ),
    const Product(
      id: 'rc-002',
      name: 'Cà Rốt Đà Lạt',
      category: 'rau-cu',
      price: 18000,
      unit: 'kg',
      stock: 150,
      description:
          'Cà rốt Đà Lạt tươi ngon, giàu vitamin A và beta-carotene, thích hợp nấu canh, xào, ép nước.',
      specs: ['Xuất xứ Đà Lạt', 'Giàu Vitamin A', 'Không phân bón hóa học'],
    ),
    const Product(
      id: 'rc-003',
      name: 'Khoai Tây Đà Lạt',
      category: 'rau-cu',
      price: 22000,
      unit: 'kg',
      stock: 180,
      description:
          'Khoai tây Đà Lạt chất lượng cao, thịt vàng, vị bùi ngọt, dùng chiên, hầm, nấu súp.',
      specs: ['Đà Lạt', 'Thịt vàng', 'Bùi ngọt', 'Xuất xứ VN'],
    ),
    // Thịt & Hải Sản
    const Product(
      id: 'tc-001',
      name: 'Thịt Heo Ba Chỉ',
      category: 'thit-ca',
      price: 145000,
      unit: 'kg',
      stock: 80,
      description:
          'Thịt heo ba chỉ tươi, có da, tỷ lệ nạc-mỡ cân đối, thích hợp chiên giòn, kho, luộc.',
      specs: ['Tươi trong ngày', 'Tỷ lệ nạc 70%', 'Kiểm dịch', 'Nguồn gốc VN'],
    ),
    const Product(
      id: 'tc-002',
      name: 'Cá Hồi Na Uy Fillet',
      category: 'thit-ca',
      price: 380000,
      unit: 'kg',
      stock: 40,
      description:
          'Cá hồi Na Uy phi lê tươi, giàu Omega-3, không gai, thích hợp nướng, áp chảo, sashimi.',
      specs: ['Nhập khẩu Na Uy', 'Omega-3 cao', 'Không gai', 'HACCP'],
    ),
    const Product(
      id: 'tc-003',
      name: 'Tôm Thẻ Tươi',
      category: 'thit-ca',
      price: 220000,
      unit: 'kg',
      stock: 60,
      description:
          'Tôm thẻ chân trắng tươi, kích cỡ 30-40 con/kg, thịt ngọt giòn, không tẩm hóa chất.',
      specs: ['30-40 con/kg', 'Tươi sống', 'Không hóa chất', 'Nguồn gốc rõ ràng'],
    ),
    // Đồ Khô & Gia Vị
    const Product(
      id: 'dk-001',
      name: 'Gạo ST25 Sóc Trăng',
      category: 'do-kho',
      price: 38000,
      unit: 'kg',
      stock: 500,
      description:
          'Gạo ST25 Sóc Trăng - giống gạo ngon nhất thế giới 2019, hạt dài thơm, cơm mềm dẻo vừa phải.',
      specs: ['Giống ST25', 'Sóc Trăng', 'Thơm tự nhiên', 'Không tẩm hương'],
    ),
    const Product(
      id: 'dk-002',
      name: 'Mì Hảo Hảo Tôm Chua Cay',
      category: 'do-kho',
      price: 4500,
      unit: 'gói 75g',
      stock: 1000,
      description:
          'Mì ăn liền Hảo Hảo vị tôm chua cay, sợi mì dai ngon, gói gia vị đậm đà đặc trưng.',
      specs: ['75g/gói', 'Vị tôm chua cay', 'Không chiên', 'Halal'],
    ),
    const Product(
      id: 'dk-003',
      name: 'Nước Mắm Phú Quốc 40°N',
      category: 'do-kho',
      price: 85000,
      unit: 'chai 500ml',
      stock: 300,
      description:
          'Nước mắm Phú Quốc truyền thống 40 độ đạm, ủ từ cá cơm biển, vị đậm ngọt tự nhiên.',
      specs: ['40°N đạm', 'Phú Quốc', 'Truyền thống', 'Không chất bảo quản'],
    ),
    // Sữa & Trứng
    const Product(
      id: 'st-001',
      name: 'Sữa Tươi Vinamilk 100%',
      category: 'sua-trung',
      price: 32000,
      unit: 'hộp 1L',
      stock: 250,
      description:
          'Sữa tươi tiệt trùng Vinamilk 100% nguyên chất, không đường, giàu canxi và vitamin D.',
      specs: ['100% sữa tươi', 'Không đường', 'Giàu Canxi', 'Vitamin D'],
    ),
    const Product(
      id: 'st-002',
      name: 'Trứng Gà Ta Sạch (Vỉ 10)',
      category: 'sua-trung',
      price: 45000,
      unit: 'vỉ 10 trứng',
      stock: 180,
      description:
          'Trứng gà ta nuôi thả vườn, lòng đỏ to vàng sậm, giàu dinh dưỡng, không hormone tăng trưởng.',
      specs: ['Gà thả vườn', 'Không hormone', 'Lòng đỏ vàng sậm', 'Tươi trong ngày'],
    ),
    const Product(
      id: 'st-003',
      name: 'Sữa Chua Vinamilk Không Đường',
      category: 'sua-trung',
      price: 28000,
      unit: 'hộp 4 hũ 100g',
      stock: 120,
      description:
          'Sữa chua Vinamilk men sống không đường, giúp hệ tiêu hóa khỏe mạnh, ít calo.',
      specs: ['Men sống', 'Không đường', 'Probiotics', 'Ít calo'],
    ),
    // Bánh & Kẹo
    const Product(
      id: 'bk-001',
      name: 'Bánh Mì Sandwich Harvest',
      category: 'banh-keo',
      price: 22000,
      unit: 'ổ 450g',
      stock: 80,
      description:
          'Bánh mì sandwich Harvest ngũ cốc nguyên cám, không chất bảo quản, thơm mềm, giàu chất xơ.',
      specs: ['Ngũ cốc nguyên cám', 'Không chất BQ', 'Giàu chất xơ', '450g'],
    ),
    const Product(
      id: 'bk-002',
      name: 'Kẹo Dẻo Haribo',
      category: 'banh-keo',
      price: 55000,
      unit: 'gói 175g',
      stock: 200,
      description:
          'Kẹo dẻo Haribo nhập khẩu Đức, đủ mọi hình dáng trái cây, vị ngọt tự nhiên, không gluten.',
      specs: ['Nhập khẩu Đức', 'Không Gluten', 'Hương trái cây tự nhiên', '175g'],
    ),
    // Đồ Uống
    const Product(
      id: 'du-001',
      name: 'Nước Suối Lavie 1.5L',
      category: 'do-uong',
      price: 10000,
      unit: 'chai 1.5L',
      stock: 500,
      description:
          'Nước khoáng thiên nhiên Lavie, pH 7.2, giàu khoáng chất tự nhiên, thích hợp cho cả gia đình.',
      specs: ['pH 7.2', 'Khoáng thiên nhiên', '1.5 Lít', 'Không gas'],
    ),
    const Product(
      id: 'du-002',
      name: 'Trà Sữa Phúc Long Lon',
      category: 'do-uong',
      price: 18000,
      unit: 'lon 330ml',
      stock: 300,
      description:
          'Trà sữa Phúc Long thương hiệu nổi tiếng, vị trà đen đậm đà pha sữa béo ngậy, tiện lợi.',
      specs: ['Phúc Long', 'Trà đen', 'Ít đường', '330ml'],
    ),
    // Đông Lạnh
    const Product(
      id: 'dl-001',
      name: 'Há Cảo Tôm Đông Lạnh',
      category: 'dong-lanh',
      price: 68000,
      unit: 'gói 400g',
      stock: 100,
      description:
          'Há cảo nhân tôm đông lạnh, hấp trong 8 phút là dùng được, nhân tôm tươi giòn ngọt.',
      specs: ['Nhân tôm tươi', '400g/gói', 'Đông lạnh IQF', 'Hấp 8 phút'],
    ),
    const Product(
      id: 'dl-002',
      name: 'Kem Tươi Walls Magnum',
      category: 'dong-lanh',
      price: 35000,
      unit: 'que 100ml',
      stock: 150,
      description:
          'Kem Magnum nhập khẩu, phủ socola Bỉ đậm đà bên ngoài, kem vani béo ngậy bên trong.',
      specs: ['Socola Bỉ', 'Kem vani', '100ml/que', 'Nhập khẩu'],
    ),
    // Thực Phẩm Chế Biến
    const Product(
      id: 'cb-001',
      name: 'Chả Lụa Hương Nam 500g',
      category: 'che-bien',
      price: 72000,
      unit: 'cây 500g',
      stock: 90,
      description:
          'Chả lụa chính hãng Hương Nam từ thịt heo nguyên chất, không phẩm màu, ăn liền hoặc nấu.',
      specs: ['Thịt heo nguyên chất', 'Không phẩm màu', '500g', 'Ăn liền'],
    ),
  ];

  List<Product> getAll() => _products;

  List<Product> getByCategory(String categoryId) =>
      _products.where((p) => p.category == categoryId).toList();

  List<Product> search(String query) {
    final q = query.toLowerCase();
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Product> getFeatured() => _products.take(6).toList();
}
