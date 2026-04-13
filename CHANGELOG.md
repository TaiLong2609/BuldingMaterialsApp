# CHANGELOG — BuldingMaterialsApp

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
