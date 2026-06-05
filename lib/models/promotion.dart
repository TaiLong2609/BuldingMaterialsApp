class Promotion {
  const Promotion({
    this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.isActive,
    required this.createdAt,
  });

  final int? id;
  final String title;
  final String code;
  final String description;
  final double discountPercent;
  final bool isActive;
  final DateTime createdAt;
}
