import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.productCount,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final int productCount;
  final Color color;
}
