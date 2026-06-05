import 'package:app_bachhoa/models/category.dart';
import 'package:app_bachhoa/models/product.dart';
import 'package:flutter/material.dart';

class ProductService {
  static const List<Category> categories = [
    Category(id: 'rau-cu', name: 'Rau củ', icon: Icons.eco_outlined, productCount: 10, color: Color(0xFF388E3C)),
    Category(id: 'trai-cay', name: 'Trái cây', icon: Icons.apple_outlined, productCount: 8, color: Color(0xFF43A047)),
    Category(id: 'thit-ca', name: 'Thịt & Hải sản', icon: Icons.set_meal_outlined, productCount: 10, color: Color(0xFFD32F2F)),
    Category(id: 'do-kho', name: 'Đồ khô & Gia vị', icon: Icons.inventory_2_outlined, productCount: 10, color: Color(0xFF795548)),
    Category(id: 'sua-trung', name: 'Sữa & Trứng', icon: Icons.egg_outlined, productCount: 8, color: Color(0xFFFFA000)),
    Category(id: 'banh-keo', name: 'Bánh & Kẹo', icon: Icons.bakery_dining_outlined, productCount: 8, color: Color(0xFFE91E63)),
    Category(id: 'do-uong', name: 'Đồ uống', icon: Icons.local_drink_outlined, productCount: 8, color: Color(0xFF0288D1)),
    Category(id: 'dong-lanh', name: 'Đông lạnh', icon: Icons.ac_unit_outlined, productCount: 6, color: Color(0xFF00838F)),
    Category(id: 'che-bien', name: 'Thực phẩm chế biến', icon: Icons.restaurant_outlined, productCount: 8, color: Color(0xFFE65100)),
    Category(id: 'cham-soc', name: 'Chăm sóc gia đình', icon: Icons.cleaning_services_outlined, productCount: 8, color: Color(0xFF5E35B1)),
  ];

  static const List<Product> _products = [
    Product(id: 'rc-001', name: 'Rau muống hữu cơ', category: 'rau-cu', price: 12000, unit: 'bó 300g', stock: 200, imageIcon: '🥬', description: 'Rau muống tươi sạch, thu hoạch trong ngày, phù hợp luộc, xào tỏi hoặc nấu canh.', specs: ['VietGAP', 'Tươi mỗi ngày', 'Không hóa chất']),
    Product(id: 'rc-002', name: 'Cà rốt Đà Lạt', category: 'rau-cu', price: 18000, unit: 'kg', stock: 150, imageIcon: '🥕', description: 'Cà rốt Đà Lạt giòn ngọt, giàu vitamin A, dùng nấu canh, hầm xương hoặc ép nước.', specs: ['Đà Lạt', 'Giàu vitamin A', 'Màu cam tự nhiên']),
    Product(id: 'rc-003', name: 'Khoai tây Đà Lạt', category: 'rau-cu', price: 22000, unit: 'kg', stock: 180, imageIcon: '🥔', description: 'Khoai tây thịt vàng, bùi thơm, dùng chiên, nghiền, nấu súp hoặc hầm bò.', specs: ['Thịt vàng', 'Bùi thơm', 'Dễ chế biến']),
    Product(id: 'rc-004', name: 'Bắp cải trắng', category: 'rau-cu', price: 16000, unit: 'kg', stock: 120, imageIcon: '🥬', description: 'Bắp cải chắc cuộn, vị ngọt nhẹ, dùng xào, luộc hoặc làm salad.', specs: ['Tươi giòn', 'Ít xơ', 'Dễ bảo quản']),
    Product(id: 'rc-005', name: 'Cà chua beef', category: 'rau-cu', price: 28000, unit: 'kg', stock: 130, imageIcon: '🍅', description: 'Cà chua chín mọng, vị chua ngọt cân bằng, thích hợp nấu sốt và salad.', specs: ['Mọng nước', 'Đỏ tự nhiên', 'Không dập nát']),
    Product(id: 'rc-006', name: 'Dưa leo baby', category: 'rau-cu', price: 26000, unit: 'kg', stock: 110, imageIcon: '🥒', description: 'Dưa leo baby giòn, ít hạt, dùng ăn sống, trộn salad hoặc làm nước detox.', specs: ['Giòn ngọt', 'Ít hạt', 'Tươi mát']),
    Product(id: 'rc-007', name: 'Nấm kim châm', category: 'rau-cu', price: 15000, unit: 'gói 150g', stock: 180, imageIcon: '🍄', description: 'Nấm kim châm sạch, dùng nhúng lẩu, xào thịt bò hoặc cuộn ba chỉ.', specs: ['Gói 150g', 'Bảo quản lạnh', 'Dùng trong ngày ngon nhất']),
    Product(id: 'rc-008', name: 'Xà lách lolo xanh', category: 'rau-cu', price: 19000, unit: 'bó 250g', stock: 90, imageIcon: '🥗', description: 'Xà lách lolo xanh tươi, lá xoăn giòn, phù hợp làm salad và ăn kèm món nướng.', specs: ['Lá giòn', 'Rửa sạch trước khi dùng', 'Ít calo']),

    Product(id: 'tcay-001', name: 'Chuối già Nam Mỹ', category: 'trai-cay', price: 26000, unit: 'kg', stock: 160, imageIcon: '🍌', description: 'Chuối chín vàng tự nhiên, ngọt thơm, tiện lợi cho bữa sáng và ăn nhẹ.', specs: ['Chín tự nhiên', 'Giàu kali', 'Ngọt thơm']),
    Product(id: 'tcay-002', name: 'Táo Envy New Zealand', category: 'trai-cay', price: 99000, unit: 'kg', stock: 80, imageIcon: '🍎', description: 'Táo Envy nhập khẩu, vỏ đỏ đẹp, thịt giòn, vị ngọt đậm.', specs: ['Nhập khẩu', 'Giòn ngọt', 'Bảo quản lạnh']),
    Product(id: 'tcay-003', name: 'Cam sành miền Tây', category: 'trai-cay', price: 42000, unit: 'kg', stock: 140, imageIcon: '🍊', description: 'Cam sành mọng nước, vị chua ngọt tự nhiên, dùng ăn tươi hoặc vắt nước.', specs: ['Mọng nước', 'Giàu vitamin C', 'Miền Tây']),
    Product(id: 'tcay-004', name: 'Dưa hấu không hạt', category: 'trai-cay', price: 18000, unit: 'kg', stock: 100, imageIcon: '🍉', description: 'Dưa hấu ruột đỏ, ngọt mát, ít hạt, giải khát tốt.', specs: ['Ruột đỏ', 'Ít hạt', 'Ngọt mát']),
    Product(id: 'tcay-005', name: 'Nho xanh Mỹ', category: 'trai-cay', price: 135000, unit: 'kg', stock: 70, imageIcon: '🍇', description: 'Nho xanh Mỹ không hạt, trái giòn, vị ngọt thanh.', specs: ['Không hạt', 'Nhập khẩu Mỹ', 'Giòn ngọt']),

    Product(id: 'tc-001', name: 'Thịt heo ba chỉ', category: 'thit-ca', price: 145000, unit: 'kg', stock: 80, imageIcon: '🥓', description: 'Ba chỉ heo tươi, tỷ lệ nạc mỡ cân đối, phù hợp kho, luộc hoặc nướng.', specs: ['Tươi trong ngày', 'Kiểm dịch', 'Nạc mỡ cân đối']),
    Product(id: 'tc-002', name: 'Ức gà phi lê', category: 'thit-ca', price: 89000, unit: 'kg', stock: 100, imageIcon: '🍗', description: 'Ức gà phi lê ít mỡ, giàu protein, phù hợp thực đơn eat clean.', specs: ['Giàu protein', 'Ít mỡ', 'Đã lọc xương']),
    Product(id: 'tc-003', name: 'Cá hồi Na Uy fillet', category: 'thit-ca', price: 380000, unit: 'kg', stock: 40, imageIcon: '🐟', description: 'Cá hồi fillet giàu Omega-3, thịt béo thơm, dùng áp chảo, nướng hoặc sashimi.', specs: ['Na Uy', 'Omega-3', 'Không xương']),
    Product(id: 'tc-004', name: 'Tôm thẻ tươi', category: 'thit-ca', price: 220000, unit: 'kg', stock: 60, imageIcon: '🦐', description: 'Tôm thẻ tươi cỡ 30-40 con/kg, thịt ngọt, dùng hấp, nướng hoặc nấu lẩu.', specs: ['30-40 con/kg', 'Tươi sạch', 'Không tẩm hóa chất']),
    Product(id: 'tc-005', name: 'Thịt bò Úc xay', category: 'thit-ca', price: 185000, unit: 'kg', stock: 55, imageIcon: '🥩', description: 'Bò Úc xay sẵn, tiện làm burger, bò viên, mì Ý sốt bò bằm.', specs: ['Bò Úc', 'Xay sẵn', 'Tiện chế biến']),
    Product(id: 'tc-006', name: 'Cá basa cắt khúc', category: 'thit-ca', price: 72000, unit: 'kg', stock: 90, imageIcon: '🐟', description: 'Cá basa cắt khúc sạch, thịt mềm béo, phù hợp kho tiêu hoặc nấu canh chua.', specs: ['Cắt khúc', 'Thịt mềm', 'Nguồn gốc rõ ràng']),

    Product(id: 'dk-001', name: 'Gạo ST25 Sóc Trăng', category: 'do-kho', price: 38000, unit: 'kg', stock: 500, imageIcon: '🍚', description: 'Gạo ST25 hạt dài, cơm mềm dẻo, thơm tự nhiên, phù hợp bữa cơm gia đình.', specs: ['ST25', 'Thơm tự nhiên', 'Hạt dài']),
    Product(id: 'dk-002', name: 'Mì Hảo Hảo tôm chua cay', category: 'do-kho', price: 4500, unit: 'gói 75g', stock: 1000, imageIcon: '🍜', description: 'Mì ăn liền vị tôm chua cay quen thuộc, tiện lợi cho bữa ăn nhanh.', specs: ['75g', 'Tôm chua cay', 'Tiện lợi']),
    Product(id: 'dk-003', name: 'Nước mắm Phú Quốc 40 độ đạm', category: 'do-kho', price: 85000, unit: 'chai 500ml', stock: 300, imageIcon: '🧂', description: 'Nước mắm truyền thống 40 độ đạm, vị đậm ngọt tự nhiên.', specs: ['40 độ đạm', 'Phú Quốc', 'Không chất bảo quản']),
    Product(id: 'dk-004', name: 'Dầu ăn Tường An', category: 'do-kho', price: 62000, unit: 'chai 1L', stock: 260, imageIcon: '🛢️', description: 'Dầu thực vật dùng chiên xào hằng ngày, hương vị nhẹ, dễ sử dụng.', specs: ['1L', 'Dầu thực vật', 'Chiên xào']),
    Product(id: 'dk-005', name: 'Đường trắng Biên Hòa', category: 'do-kho', price: 28000, unit: 'kg', stock: 240, imageIcon: '🍬', description: 'Đường tinh luyện hạt trắng, dùng pha chế, nấu ăn và làm bánh.', specs: ['Tinh luyện', 'Hạt trắng', 'Dễ tan']),
    Product(id: 'dk-006', name: 'Bột ngọt Ajinomoto', category: 'do-kho', price: 39000, unit: 'gói 454g', stock: 220, imageIcon: '🧂', description: 'Gia vị nêm nếm quen thuộc, giúp món ăn tròn vị hơn.', specs: ['454g', 'Dễ nêm', 'Thương hiệu Nhật']),

    Product(id: 'st-001', name: 'Sữa tươi Vinamilk không đường', category: 'sua-trung', price: 32000, unit: 'hộp 1L', stock: 250, imageIcon: '🥛', description: 'Sữa tươi tiệt trùng không đường, giàu canxi và vitamin D.', specs: ['1L', 'Không đường', 'Giàu canxi']),
    Product(id: 'st-002', name: 'Trứng gà ta sạch', category: 'sua-trung', price: 45000, unit: 'vỉ 10 trứng', stock: 180, imageIcon: '🥚', description: 'Trứng gà ta sạch, lòng đỏ đẹp, phù hợp chiên, luộc, làm bánh.', specs: ['Vỉ 10', 'Tươi mới', 'Không hormone']),
    Product(id: 'st-003', name: 'Sữa chua Vinamilk không đường', category: 'sua-trung', price: 28000, unit: 'lốc 4 hũ', stock: 120, imageIcon: '🍶', description: 'Sữa chua men sống không đường, hỗ trợ tiêu hóa, ít calo.', specs: ['Lốc 4', 'Men sống', 'Ít calo']),
    Product(id: 'st-004', name: 'Phô mai Con Bò Cười', category: 'sua-trung', price: 36000, unit: 'hộp 8 miếng', stock: 100, imageIcon: '🧀', description: 'Phô mai béo thơm, tiện ăn sáng, ăn nhẹ hoặc kẹp bánh mì.', specs: ['8 miếng', 'Giàu canxi', 'Tiện lợi']),

    Product(id: 'bk-001', name: 'Bánh mì sandwich Harvest', category: 'banh-keo', price: 22000, unit: 'ổ 450g', stock: 80, imageIcon: '🍞', description: 'Sandwich mềm thơm, tiện cho bữa sáng, kẹp trứng, xúc xích hoặc phô mai.', specs: ['450g', 'Mềm thơm', 'Dùng ăn sáng']),
    Product(id: 'bk-002', name: 'Kẹo dẻo Haribo', category: 'banh-keo', price: 55000, unit: 'gói 175g', stock: 200, imageIcon: '🍭', description: 'Kẹo dẻo trái cây nhập khẩu, hương vị vui nhộn cho trẻ em và gia đình.', specs: ['175g', 'Hương trái cây', 'Dẻo ngọt']),
    Product(id: 'bk-003', name: 'Bánh Oreo socola', category: 'banh-keo', price: 24000, unit: 'gói 133g', stock: 190, imageIcon: '🍪', description: 'Bánh quy socola kẹp kem vani, ăn trực tiếp hoặc dùng pha chế.', specs: ['133g', 'Socola', 'Kẹp kem']),
    Product(id: 'bk-004', name: 'Snack khoai tây Lay’s', category: 'banh-keo', price: 18000, unit: 'gói 90g', stock: 210, imageIcon: '🍟', description: 'Snack khoai tây giòn rụm, nhiều hương vị, phù hợp ăn vặt.', specs: ['90g', 'Giòn rụm', 'Ăn vặt']),

    Product(id: 'du-001', name: 'Nước suối Lavie', category: 'do-uong', price: 10000, unit: 'chai 1.5L', stock: 500, imageIcon: '💧', description: 'Nước khoáng thiên nhiên Lavie, thanh mát, phù hợp sử dụng hằng ngày.', specs: ['1.5L', 'Khoáng thiên nhiên', 'Không gas']),
    Product(id: 'du-002', name: 'Trà sữa Phúc Long lon', category: 'do-uong', price: 18000, unit: 'lon 330ml', stock: 300, imageIcon: '🧋', description: 'Trà sữa đóng lon vị trà đậm, béo nhẹ, tiện mang theo.', specs: ['330ml', 'Trà đậm', 'Tiện lợi']),
    Product(id: 'du-003', name: 'Coca-Cola lon', category: 'do-uong', price: 11000, unit: 'lon 320ml', stock: 400, imageIcon: '🥤', description: 'Nước ngọt có gas vị cola sảng khoái, dùng lạnh ngon hơn.', specs: ['320ml', 'Có gas', 'Uống lạnh']),
    Product(id: 'du-004', name: 'Nước cam ép Twister', category: 'do-uong', price: 15000, unit: 'chai 455ml', stock: 260, imageIcon: '🧃', description: 'Nước cam ép đóng chai, vị chua ngọt dễ uống, bổ sung vitamin C.', specs: ['455ml', 'Vị cam', 'Vitamin C']),

    Product(id: 'dl-001', name: 'Há cảo tôm đông lạnh', category: 'dong-lanh', price: 68000, unit: 'gói 400g', stock: 100, imageIcon: '🥟', description: 'Há cảo nhân tôm đông lạnh, hấp nhanh trong vài phút, tiện cho bữa xế.', specs: ['400g', 'Nhân tôm', 'Bảo quản đông']),
    Product(id: 'dl-002', name: 'Kem Magnum vani socola', category: 'dong-lanh', price: 35000, unit: 'que 100ml', stock: 150, imageIcon: '🍦', description: 'Kem vani phủ socola giòn, béo thơm, dùng ngay sau khi mở bao bì.', specs: ['100ml', 'Phủ socola', 'Bảo quản đông']),
    Product(id: 'dl-003', name: 'Khoai tây chiên đông lạnh', category: 'dong-lanh', price: 52000, unit: 'gói 500g', stock: 120, imageIcon: '🍟', description: 'Khoai tây cắt sẵn, chiên hoặc nướng nhanh, giòn ngon.', specs: ['500g', 'Cắt sẵn', 'Chiên nhanh']),

    Product(id: 'cb-001', name: 'Chả lụa Hương Nam', category: 'che-bien', price: 72000, unit: 'cây 500g', stock: 90, imageIcon: '🍖', description: 'Chả lụa làm từ thịt heo nguyên chất, ăn liền hoặc dùng kèm bánh mì, cơm tấm.', specs: ['500g', 'Ăn liền', 'Không phẩm màu']),
    Product(id: 'cb-002', name: 'Xúc xích Đức Việt', category: 'che-bien', price: 56000, unit: 'gói 500g', stock: 140, imageIcon: '🌭', description: 'Xúc xích tiệt trùng tiện lợi, chiên, nướng hoặc ăn kèm mì gói.', specs: ['500g', 'Tiệt trùng', 'Dễ chế biến']),
    Product(id: 'cb-003', name: 'Đậu hũ non Ichiban', category: 'che-bien', price: 16000, unit: 'hộp 300g', stock: 130, imageIcon: '🍱', description: 'Đậu hũ non mềm mịn, dùng nấu canh, sốt Tứ Xuyên hoặc hấp trứng.', specs: ['300g', 'Mềm mịn', 'Bảo quản lạnh']),
    Product(id: 'cb-004', name: 'Kim chi cải thảo', category: 'che-bien', price: 42000, unit: 'hộp 500g', stock: 90, imageIcon: '🥬', description: 'Kim chi cải thảo vị chua cay hài hòa, ăn kèm cơm, mì hoặc nướng BBQ.', specs: ['500g', 'Chua cay', 'Bảo quản lạnh']),

    Product(id: 'cs-001', name: 'Nước rửa chén Sunlight chanh', category: 'cham-soc', price: 38000, unit: 'chai 750g', stock: 220, imageIcon: '🧽', description: 'Nước rửa chén hương chanh, sạch dầu mỡ, dịu nhẹ với da tay.', specs: ['750g', 'Hương chanh', 'Sạch dầu mỡ']),
    Product(id: 'cs-002', name: 'Bột giặt OMO Comfort', category: 'cham-soc', price: 125000, unit: 'túi 3.5kg', stock: 130, imageIcon: '🧺', description: 'Bột giặt sạch sâu, lưu hương, phù hợp giặt tay và giặt máy.', specs: ['3.5kg', 'Sạch sâu', 'Lưu hương']),
    Product(id: 'cs-003', name: 'Khăn giấy Bless You', category: 'cham-soc', price: 32000, unit: 'lốc 3 gói', stock: 200, imageIcon: '🧻', description: 'Khăn giấy mềm mịn, dai, phù hợp dùng trong gia đình và văn phòng.', specs: ['Lốc 3', 'Mềm mịn', 'Dai giấy']),
    Product(id: 'cs-004', name: 'Nước lau sàn Gift lavender', category: 'cham-soc', price: 54000, unit: 'chai 1L', stock: 120, imageIcon: '🧴', description: 'Nước lau sàn hương lavender, làm sạch bụi bẩn và lưu hương dễ chịu.', specs: ['1L', 'Lavender', 'Sạch bóng']),
  ];

  List<Product> getAll() => _products;

  List<Product> getByCategory(String categoryId) => _products.where((p) => p.category == categoryId).toList();

  List<Product> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAll();
    return _products.where((p) => p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)).toList();
  }

  List<Product> getFeatured() => _products.take(8).toList();
}
