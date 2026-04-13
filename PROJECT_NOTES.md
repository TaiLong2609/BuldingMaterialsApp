# PROJECT NOTES — BuldingMaterialsApp (VLXD Store)

> **Đọc file này trước khi làm việc** để tránh mất context giữa các session AI.
> Cập nhật mỗi khi có thay đổi kiến trúc quan trọng.

---

## 1. Mục tiêu dự án

Ứng dụng quản lý vật liệu xây dựng (VLXD) Flutter, xây dựng từ Stitch project
**"Quản Lý Đơn Hàng - Orders"** với design system **Industrial Sophistication**.

---

## 2. Tài khoản demo

| Username | Password | Role | Màn hình |
|---|---|---|---|
| `admin` | `admin123` | Admin | Đơn hàng (tất cả) + Danh mục |
| `quanly` | `ql123` | Manager | Đơn hàng (tất cả) + Danh mục + action buttons |
| `user` | `user123` | Customer | Home + Danh mục + Giỏ hàng + Đơn hàng (của mình) |

Seed file: `assets/seed_accounts.txt`

---

## 3. Kiến trúc

```
lib/
├── app/
│   └── app_root.dart          # Theme + Provider setup + routing
├── models/
│   ├── product.dart           # Product model
│   ├── category.dart          # Category model  
│   ├── cart_item.dart         # CartItem model
│   ├── order.dart             # Order model + OrderStatus enum
│   ├── user_role.dart         # UserRole enum (admin/manager/customer)
│   └── user_session.dart      # UserSession model
├── services/
│   ├── auth_service.dart      # Login/register, đọc seed_accounts.txt
│   ├── product_service.dart   # 18 mock products, 8 categories
│   ├── cart_service.dart      # ChangeNotifier, add/remove/update/clear
│   └── order_service.dart     # SINGLETON, mock orders, getByCustomer()
├── screens/
│   ├── login_page.dart        # Đăng nhập → navigate RegisterPage
│   ├── register_page.dart     # Đăng ký customer mới
│   ├── home_page.dart         # Hero, search, categories, featured
│   ├── category_page.dart     # Grid danh mục
│   ├── product_list_page.dart # Filter + search + grid
│   ├── product_detail_page.dart # Detail + Review section
│   ├── cart_page.dart         # Giỏ hàng + checkout
│   ├── orders_page.dart       # Đơn hàng (filter theo role)
│   └── placeholder_page.dart  # Không còn dùng
└── widgets/
    ├── app_bottom_nav.dart    # Scaffold chính: AppBar + Drawer + BottomNav
    ├── app_drawer.dart        # Side drawer với header + nav + logout
    └── product_card.dart      # Card sản phẩm
```

---

## 4. Design System — Industrial Sophistication

### Colors
| Token | Value | Dùng cho |
|---|---|---|
| `primary` | `#000666` | AppBar, buttons, active states |
| `primaryContainer` | `#1A237E` | Gradient end, drawer header |
| `secondary` | `#8F4E00` | Price, CTA buttons |
| `secondaryContainer` | `#FF8F00` | Accent |
| `surface` | `#F9F9F9` | Card backgrounds |
| `surfaceContainerLow` | `#F3F3F3` | Page backgrounds |

### Typography
- **Tiêu đề**: `Work Sans` (weight 600-800)
- **Nội dung**: `Inter` (weight 400-600)

### Principles
- **No-line rule**: Không dùng Divider/border; phân cách bằng tonal layering
- **Tonal layering**: `surface` → `surfaceContainerLow` → `surfaceContainerHighest`
- **Asymmetrical spacing**: Padding không đều (top/bottom khác left/right)

---

## 5. State Management

- **`CartService`**: `ChangeNotifier`, wrapped bởi `ChangeNotifierProvider` trong `AppRoot`
- **`OrderService`**: **Singleton** — mọi nơi gọi `OrderService()` đều dùng cùng instance
- **Auth state**: Quản lý tại `AppRoot._session` (setState-based)

---

## 6. Navigation Flow

```
LoginPage ──────────────────────────────────► RegisterPage
    │
    ▼ (login success)
AppBottomNav (Scaffold chính)
    ├── AppBar (hamburger ☰ → Drawer)
    ├── AppDrawer (side navigation)
    ├── IndexedStack (các tab)
    │   ├── [Customer] Home → ProductList → ProductDetail
    │   ├── [Customer] CategoryPage → ProductList → ProductDetail
    │   ├── [Customer] CartPage (checkout → tạo Order)
    │   ├── [All]      OrdersPage (filter theo role/username)
    │   └── [Staff]    CategoryPage
    └── NavigationBar (bottom)
```

---

## 7. Logic phân quyền

### Customer
- Thấy: Home, Danh mục, Giỏ hàng, Đơn hàng (chỉ của mình)
- `OrdersPage` gọi `orderService.getByCustomer(session.username)`
- Không có action buttons trên OrderCard

### Admin / Manager
- Thấy: Đơn hàng (tất cả), Danh mục
- `OrdersPage` gọi `orderService.getAll()`
- Có action buttons: Xác nhận → Bắt đầu giao → Đã giao xong | Huỷ đơn

---

## 8. Những việc còn có thể làm (backlog)

- [ ] Kết nối backend thật (thay mock services)
- [ ] Persistent cart (SharedPreferences hoặc sqflite)
- [ ] Push notification khi đơn hàng cập nhật trạng thái
- [ ] Trang Profile / Cài đặt tài khoản
- [ ] Tìm kiếm toàn cục + filter nâng cao
- [ ] Dark mode
- [ ] Pagination cho danh sách sản phẩm
- [ ] Image upload cho sản phẩm (thay icon placeholder)
- [ ] Reviews: persist + backend sync

---

## 9. Lưu ý kỹ thuật

### OrderService Singleton
```dart
// Đã chuyển sang singleton để đơn hàng đặt từ CartPage
// hiển thị ngay ở OrdersPage mà không cần restart
static final OrderService _instance = OrderService._internal();
factory OrderService() => _instance;
OrderService._internal();
```

### Thêm đơn hàng từ Cart
```dart
// CartPage → _checkout()
OrderService().placeOrder(
  customerName: session.username,  // QUAN TRỌNG: phải dùng username
  address: ...,
  items: cart.items.toList(),
);
```

### Thêm mock data cho user mới
Vào `order_service.dart` → `_generateMockOrders()`, thêm `Order` với `customerName: 'tên_user'`

### Thêm tài khoản demo
Vào `assets/seed_accounts.txt`, thêm dòng: `username|password|ROLE`  
Roles hợp lệ: `ADMIN`, `MANAGER`, `CUSTOMER`
