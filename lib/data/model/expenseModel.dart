// Expense sınıfını oluştururken createdAt'ı kullan
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final double price;
  final String category;
  final DateTime date; // createdAt'ı DateTime olarak kullan

  Expense({
    required this.price,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      price: json['price'],
      category: json['category'],
      date: (json['createdAt'] as Timestamp).toDate(), // Firestore'dan alırken DateTime'a çevir
    );
  }
}
