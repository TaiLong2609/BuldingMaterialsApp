import 'package:app_quanlyxaydung/models/category.dart';
import 'package:app_quanlyxaydung/models/product.dart';
import 'package:flutter/material.dart';

class ProductService {
  static final List<Category> categories = const [
    Category(
      id: 'xi-mang',
      name: 'Xi Măng',
      icon: Icons.inventory_2_outlined,
      productCount: 8,
      color: Color(0xFF546E7A),
    ),
    Category(
      id: 'gach',
      name: 'Gạch',
      icon: Icons.view_module_outlined,
      productCount: 12,
      color: Color(0xFFBF360C),
    ),
    Category(
      id: 'sat-thep',
      name: 'Sắt Thép',
      icon: Icons.linear_scale,
      productCount: 10,
      color: Color(0xFF37474F),
    ),
    Category(
      id: 'cat-da',
      name: 'Cát & Đá',
      icon: Icons.terrain_outlined,
      productCount: 6,
      color: Color(0xFF795548),
    ),
    Category(
      id: 'son',
      name: 'Sơn',
      icon: Icons.format_paint_outlined,
      productCount: 15,
      color: Color(0xFF1565C0),
    ),
    Category(
      id: 'go',
      name: 'Gỗ & Ván',
      icon: Icons.carpenter,
      productCount: 9,
      color: Color(0xFF4E342E),
    ),
    Category(
      id: 'ong-nuoc',
      name: 'Ống Nước',
      icon: Icons.water_outlined,
      productCount: 7,
      color: Color(0xFF00695C),
    ),
    Category(
      id: 'dien',
      name: 'Điện & Đèn',
      icon: Icons.bolt_outlined,
      productCount: 11,
      color: Color(0xFFF57F17),
    ),
  ];

  static final List<Product> _products = [
    // Xi Măng
    const Product(
      id: 'xm-001',
      name: 'Xi Măng Hà Tiên PCB40',
      category: 'xi-mang',
      price: 95000,
      unit: 'bao 50kg',
      stock: 500,
      description:
          'Xi măng Portland hỗn hợp PCB40 Hà Tiên, độ bền cao, phù hợp xây dựng dân dụng và công nghiệp.',
      specs: ['PCB40', 'Bao 50kg', 'Cường độ nén ≥40 MPa', 'Grade A'],
    ),
    const Product(
      id: 'xm-002',
      name: 'Xi Măng Vicem ',
      category: 'xi-mang',
      price: 92000,
      unit: 'bao 50kg',
      stock: 350,
      description:
          'Xi măng Vicem Hoàng Thạch PCB40, chất lượng cao, được kiểm định đạt chuẩn TCVN 6260.',
      specs: ['PCB40', 'TCVN 6260', 'Bao 50kg', 'Grade A'],
    ),
    const Product(
      id: 'xm-003',
      name: 'Xi Măng Insee PC40',
      category: 'xi-mang',
      price: 98000,
      unit: 'bao 50kg',
      stock: 420,
      description:
          'Xi măng INSEE PC40 nhập khẩu Thái Lan, độ bền vượt trội, thích hợp cho các công trình lớn.',
      specs: ['PC40', 'Nhập khẩu', 'Bao 50kg', 'ISO 9001'],
    ),
    // Gạch
    const Product(
      id: 'gach-001',
      name: 'Gạch Đặc Tuynel 2 lỗ',
      category: 'gach',
      price: 1800,
      unit: 'viên',
      stock: 5000,
      description:
          'Gạch đặc tuynel 2 lỗ tiêu chuẩn, kích thước 220x105x60, đáp ứng yêu cầu xây dựng dân dụng.',
      specs: ['220×105×60mm', '2 lỗ', 'Mác 75', 'TCVN 1450'],
    ),
    const Product(
      id: 'gach-002',
      name: 'Gạch Thẻ Đồng Nai',
      category: 'gach',
      price: 2200,
      unit: 'viên',
      stock: 3200,
      description:
          'Gạch thẻ Đồng Nai nung đỏ đều, độ háo nước thấp, dùng lát tường, ốp mặt công trình.',
      specs: ['200×100×60mm', 'Hấp thụ nước <10%', 'Mác 100'],
    ),
    const Product(
      id: 'gach-003',
      name: 'Gạch Bê Tông Nhẹ AAC',
      category: 'gach',
      price: 3500,
      unit: 'viên',
      stock: 2500,
      description:
          'Gạch bê tông nhẹ AAC cách nhiệt, cách âm tốt, nhẹ hơn gạch đỏ 4 lần, tiết kiệm vữa.',
      specs: ['600×200×100mm', 'D600', 'Cách nhiệt R=0.25', 'Chống cháy 4h'],
    ),
    // Sắt Thép
    const Product(
      id: 'st-001',
      name: 'Thép Tròn D10 Hòa Phát',
      category: 'sat-thep',
      price: 185000,
      unit: 'thanh 11.7m',
      stock: 800,
      description:
          'Thép tròn vằn D10 Hòa Phát CB300-V, chịu lực tốt, dùng đổ bê tông dầm, cột, sàn.',
      specs: ['D10mm', 'CB300-V', 'Dài 11.7m', 'Hòa Phát'],
    ),
    const Product(
      id: 'st-002',
      name: 'Thép Tròn D16 Hòa Phát',
      category: 'sat-thep',
      price: 280000,
      unit: 'thanh 11.7m',
      stock: 600,
      description:
          'Thép tròn vằn D16 CB300-V Hòa Phát, tiêu chuẩn TCVN 1651, dùng cho công trình trung bình.',
      specs: ['D16mm', 'CB300-V', 'Dài 11.7m', 'TCVN 1651'],
    ),
    const Product(
      id: 'st-003',
      name: 'Thép Hình U80 Việt Nhật',
      category: 'sat-thep',
      price: 580000,
      unit: 'thanh 6m',
      stock: 200,
      description:
          'Thép hình chữ U80 Việt Nhật, dùng làm khung kết cấu, xà gồ, khung nhà thép.',
      specs: ['U80×45×5mm', 'SS400', 'Dài 6m', 'Việt Nhật'],
    ),
    // Cát & Đá
    const Product(
      id: 'cd-001',
      name: 'Cát Xây Dựng (Cát Đen)',
      category: 'cat-da',
      price: 280000,
      unit: 'm³',
      stock: 150,
      description:
          'Cát đen (cát san lấp/xây tô), hàm lượng tạp chất thấp, phù hợp trộn vữa xây tô.',
      specs: ['Module 2.0-2.5', 'Hàm lượng bùn <5%', 'TCVN 7570'],
    ),
    const Product(
      id: 'cd-002',
      name: 'Đá 1×2 Granit',
      category: 'cat-da',
      price: 320000,
      unit: 'm³',
      stock: 120,
      description:
          'Đá dăm granit kích thước 10-20mm, cường độ cao, dùng trộn bê tông móng, sàn, cột.',
      specs: ['10-20mm', 'Granit', 'Cường độ ≥300 MPa', 'TCVN 7570'],
    ),
    // Sơn
    const Product(
      id: 'son-001',
      name: 'Sơn Dulux Weathershield 5L',
      category: 'son',
      price: 345000,
      unit: 'thùng 5L',
      stock: 180,
      description:
          'Sơn ngoại thất Dulux Weathershield chống thấm, chống mốc, bền màu 10 năm.',
      specs: ['5 Lít', 'Ngoại thất', 'Chống mốc', 'Bền 10 năm'],
    ),
    const Product(
      id: 'son-002',
      name: 'Sơn Jotun Essence 18L',
      category: 'son',
      price: 890000,
      unit: 'thùng 18L',
      stock: 95,
      description:
          'Sơn nội thất Jotun Essence cao cấp, không mùi, khô nhanh 30 phút, bề mặt mịn.',
      specs: ['18 Lít', 'Nội thất', 'Không mùi', 'VOC thấp'],
    ),
    // Gỗ & Ván
    const Product(
      id: 'go-001',
      name: 'Ván MDF 18mm 1220×2440',
      category: 'go',
      price: 250000,
      unit: 'tờ',
      stock: 300,
      description:
          'Ván gỗ MDF (Medium Density Fiberboard) 18mm, bề mặt phẳng mịn, dùng đóng nội thất.',
      specs: ['18mm', '1220×2440mm', 'E1 Formaldehyde', 'Chống ẩm cơ bản'],
    ),
    const Product(
      id: 'go-002',
      name: 'Gỗ Thông Xẻ 40×90',
      category: 'go',
      price: 45000,
      unit: 'thanh 3m',
      stock: 450,
      description:
          'Gỗ thông New Zealand xẻ 40×90mm, đã sấy khô, dùng làm khung, nẹp, đà gỗ.',
      specs: ['40×90mm', 'Dài 3m', 'MC 12-15%', 'Đã qua sấy'],
    ),
    // Ống Nước
    const Product(
      id: 'on-001',
      name: 'Ống Nhựa PPR Tiền Phong D20',
      category: 'ong-nuoc',
      price: 12000,
      unit: 'thanh 4m',
      stock: 600,
      description:
          'Ống nhựa PPR Tiền Phong D20 PN20, chịu nhiệt độ cao đến 95°C, dùng cấp nước nóng lạnh.',
      specs: ['D20mm', 'PN20', '4m/thanh', 'Chịu nhiệt 95°C'],
    ),
    const Product(
      id: 'on-002',
      name: 'Ống PVC Bình Minh D90',
      category: 'ong-nuoc',
      price: 85000,
      unit: 'thanh 4m',
      stock: 280,
      description:
          'Ống PVC Bình Minh D90 Class D, dùng thoát nước thải, chịu lực nén đất tốt.',
      specs: ['D90mm', 'Class D', '4m/thanh', 'Thoát nước'],
    ),
    // Điện
    const Product(
      id: 'dien-001',
      name: 'Dây Điện Cadivi 2.5mm² (100m)',
      category: 'dien',
      price: 420000,
      unit: 'cuộn 100m',
      stock: 220,
      description:
          'Dây điện đơn lõi đồng Cadivi 2.5mm², vỏ PVC chịu nhiệt 70°C, dùng đi dây điện sinh hoạt.',
      specs: ['2.5mm²', '100m/cuộn', 'PVC 70°C', 'IEC 60227'],
    ),
    const Product(
      id: 'dien-002',
      name: 'Đèn LED Panel 600×600 40W',
      category: 'dien',
      price: 185000,
      unit: 'bộ',
      stock: 150,
      description:
          'Đèn LED panel âm trần 600×600mm 40W, ánh sáng trắng 6500K, tuổi thọ 30.000 giờ.',
      specs: ['40W', '6500K', '600×600mm', '30.000 giờ'],
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
