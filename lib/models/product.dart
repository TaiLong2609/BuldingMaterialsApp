class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    required this.description,
    this.specs = const [],
    this.imageIcon,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final int stock;
  final String description;
  final List<String> specs;
  final String? imageIcon;

  String get formattedPrice {
    final p = price.toInt();
    final s = p.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '$bufđ/$unit';
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? unit,
    int? stock,
    String? description,
    List<String>? specs,
    String? imageIcon,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      specs: specs ?? this.specs,
      imageIcon: imageIcon ?? this.imageIcon,
    );
  }
}
