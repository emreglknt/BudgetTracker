
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthChart {
  final double price;
  final String category;
  final DateTime createdAt;

  MonthChart({
    required this.price,
    required this.category,
    required this.createdAt,
  });

  factory MonthChart.fromJson(Map<String, dynamic> json) {
    return MonthChart(
      price: json['price'],
      category: json['category'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
