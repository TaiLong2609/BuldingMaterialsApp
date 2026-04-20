# CHANGELOG — Bách Hóa Online App

> File này ghi lại toàn bộ thay đổi theo phiên làm việc.
> AI và developer đọc file này để tiếp tục mà không mất context.

---

## [Session 4] — 2026-04-20

### ✅ Chuyển đổi nội dung: VLXD → Bách Hóa (Food Store)

> Giữ nguyên 100% kiến trúc, business logic, design system — chỉ thay nội dung.

#### Rename package
- **`pubspec.yaml`** — Đổi `name: app_quanlyxaydung` → `name: app_bachhoa`, cập nhật description
- **Toàn bộ 28 file `.dart`** — Bulk rename tất cả imports `package:app_quanlyxaydung/` → `package:app_bachhoa/`
- **`test/widget_test.dart`** — Cập nhật imports

#### Thay nội dung thực phẩm
- **`lib/services/product_service.dart`** — Thay 8 danh mục VLXD + 18 sản phẩm xây dựng bằng:
  - 8 danh mục thực phẩm: Rau Củ, Thịt & Hải Sản, Đồ Khô & Gia Vị, Sữa & Trứng, Bánh & Kẹo, Đồ Uống, Đông Lạnh, Thực Phẩm Chế Biến
  - 18+ sản phẩm thực phẩm mock: Gạo ST25, Cá Hồi Na Uy, Tôm Thẻ Tươi, Rau Muống Hữu Cơ, Sữa Vinamilk, Trứng Gà Ta, Nước Mắm Phú Quốc...
  - Giữ nguyên toàn bộ methods: `getAll`, `getByCategory`, `search`, `getFeatured`
- **`lib/services/order_service.dart`** — Cập nhật mock orders trỏ đúng index sản phẩm thực phẩm mới
  - Giữ nguyên Singleton pattern, `placeOrder`, `updateStatus`, `getByCustomer`, `getAll`

#### Cập nhật branding / text labels
- **`lib/app/app_root.dart`** — `title: 'VLXD'` → `title: 'Bách Hóa Online'`
- **`lib/widgets/app_bottom_nav.dart`** — Tab title `'VLXD Store'` → `'Bách Hóa Online'`
- **`lib/widgets/app_drawer.dart`** — Role label `'Quản lý VLXD'` → `'Quản lý Bách Hóa'`
- **`lib/screens/system user/home_page.dart`**:
  - App header: `'VLXD Store'` → `'Bách Hóa Online'`
  - Search hint: `'Tìm xi măng, gạch...'` → `'Tìm rau củ, thịt cá, sữa...'`
  - Hero banner text: `'Giảm 15% Xi Măng & Vật Liệu Xây'` → `'Giảm 20% Rau Củ & Thực Phẩm Tươi'`
  - Hero banner icon: `business_center_outlined` → `storefront_outlined`
  - Hero CTA link: category `xi-mang` → `rau-cu`
  - Featured label: `'Sản phẩm nổi bật'` → `'Sản phẩm bán chạy'`
- **`lib/screens/system user/login_page.dart`**:
  - Brand title: `'VLXD'` → `'Bách Hóa'`
  - Tagline: `'Khám phá vật liệu xây dựng bạn cần.'` → `'Thực phẩm tươi sạch, giao hàng tận nhà.'`

#### Tạo thư mục assets
- **`assets/products/`** — Tạo thư mục để lưu ảnh sản phẩm sau này

#### Cập nhật docs
- **`PROJECT_NOTES.md`** — Cập nhật toàn bộ: tên app, package name, danh mục thực phẩm

---



> File này ghi lại toàn bộ thay đổi theo phiên làm việc.
> AI và developer đọc file này để tiếp tục mà không mất context.

---

## [Session 3] — 2026-04-13

### ✅ Thêm mới
- **`lib/widgets/app_drawer.dart`** — Drawer bên trái với:
  - Header gradient (primary → primaryContainer) chứa avatar chữ cái + username + role badge
  - Nav items highlight tab đang active, icon filled/outlined
  - Role-aware nav: 2 tabs (staff) vs 4 tabs (customer)
  - Logout tile màu đỏ với confirm dialog
- **`lib/screens/product_detail_page.dart`** — Thêm Review Section:
  - Rating summary card: điểm trung bình + bar chart 5 sao
  - Danh sách review cards (avatar, stars, date, comment)
  - Bottom sheet viết đánh giá mới (star picker + TextField)
  - Review được gắn `session.username` khi submit

### ✅ Cập nhật
- **`lib/widgets/app_bottom_nav.dart`**:
  - Thêm `AppBar` chung với hamburger menu (☰)
  - Badge giỏ hàng trên AppBar cho customer
  - Title AppBar thay đổi động theo tab
  - Tích hợp `AppDrawer`
- **`lib/screens/category_page.dart`** — Xoá SliverAppBar trùng (đã có AppBar chung)
- **`lib/screens/cart_page.dart`** — Xoá SliverAppBar, thêm TextButton "Xoá tất cả" inline
- **`lib/screens/orders_page.dart`** — Xoá SliverAppBar, dùng Column + TabBar + Expanded
- **`lib/services/order_service.dart`**:
  - Chuyển thành **Singleton** (`factory OrderService() => _instance`) — đơn đặt từ Cart hiển thị ngay ở OrdersPage
  - Thêm `getByCustomer(username)` và `getByCustomerAndStatus(username, status)`
  - Thêm 3 mock orders cho tài khoản `user`
- **`lib/screens/orders_page.dart`** — Customer chỉ thấy đơn hàng của chính mình (filter theo `session.username`)
- **`assets/seed_accounts.txt`** — Thêm `user|user123|CUSTOMER`
- **`lib/services/auth_service.dart`** — Thêm `'CUSTOMER' => UserRole.customer` vào parser

---

## [Session 2] — 2026-04-13

### ✅ Thêm mới
- **`lib/screens/product_detail_page.dart`** — Spec chips, quantity picker, total row, CTA buttons
- **`lib/screens/cart_page.dart`** — Item tiles, quantity controls, checkout dialog
- **`lib/screens/orders_page.dart`** — TabBar 5 trạng thái, stats banner, action buttons (manager)
- **`lib/screens/register_page.dart`** — Form validate phone/password, gradient header
- **`lib/widgets/app_bottom_nav.dart`** — NavigationBar role-aware (2 tab staff / 4 tab customer)

### ✅ Cập nhật
- **`lib/app/app_root.dart`** — Industrial Sophistication theme, Provider wrap, routing thật
- **`lib/screens/login_page.dart`** — Link sang RegisterPage, xoá logic `_isRegister` cũ

---

## [Session 1] — 2026-04-13

### ✅ Thêm mới
- **`lib/models/product.dart`** — Model sản phẩm VLXD
- **`lib/models/category.dart`** — Model danh mục
- **`lib/models/cart_item.dart`** — Model item giỏ hàng
- **`lib/models/order.dart`** — Model đơn hàng + enum `OrderStatus`
- **`lib/services/product_service.dart`** — 18 sản phẩm mock, 8 danh mục VLXD
- **`lib/services/cart_service.dart`** — `ChangeNotifier`, add/remove/updateQuantity/clear
- **`lib/services/order_service.dart`** — 10 mock orders (7 chung + 3 cho user)
- **`lib/widgets/product_card.dart`** — Card sản phẩm với add-to-cart animation
- **`lib/screens/home_page.dart`** — Hero banner, search, quick categories, featured products
- **`lib/screens/category_page.dart`** — Stats bar, grid 2 cột
- **`lib/screens/product_list_page.dart`** — Filter tabs + search + grid

### ✅ Cập nhật
- **`pubspec.yaml`** — Thêm `google_fonts`, `provider`
