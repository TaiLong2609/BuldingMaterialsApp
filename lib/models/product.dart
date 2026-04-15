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
    this.imageAsset,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final int stock;
  final String description;
  final List<String> specs;
  final String? imageAsset;

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
}
