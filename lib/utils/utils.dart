
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioProvider{
  static Dio provideDio(){
    Dio dio = Dio(BaseOptions(baseUrl:"http://10.0.2.2:5000/api/"));
    return dio;
  }
}





// Expense Categories List
final List<Map<String, dynamic>> categories = [
  {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.red},
  {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
  {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple},
  {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.orange},
  {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.yellow},
  {'name': 'Health', 'icon': Icons.health_and_safety, 'color': Colors.green},
  {'name': 'Education', 'icon': Icons.school, 'color': Colors.teal},
  {'name': 'Travel', 'icon': Icons.flight, 'color': Colors.lightBlue},
  {'name': 'Utilities', 'icon': Icons.lightbulb, 'color': Colors.amber},
  {'name': 'Rent', 'icon': Icons.home, 'color': Colors.brown},
  {'name': 'Subscriptions', 'icon': Icons.subscriptions, 'color': Colors.deepPurple},
  {'name': 'Insurance', 'icon': Icons.security, 'color': Colors.blueGrey},
  {'name': 'Groceries', 'icon': Icons.local_grocery_store, 'color': Colors.pink},
  {'name': 'Fitness', 'icon': Icons.fitness_center, 'color': Colors.greenAccent},
  {'name': 'Pets', 'icon': Icons.pets, 'color': Colors.deepOrange},
  {'name': 'Clothing', 'icon': Icons.checkroom, 'color': Colors.indigo},
  {'name': 'Charity', 'icon': Icons.volunteer_activism, 'color': Colors.redAccent},
  {'name': 'Gifts', 'icon': Icons.card_giftcard, 'color': Colors.yellowAccent},
  {'name': 'Beauty', 'icon': Icons.spa, 'color': Colors.purpleAccent},
  {'name': 'Electronics', 'icon': Icons.devices_other, 'color': Colors.blueAccent},
  {'name': 'Furniture', 'icon': Icons.chair, 'color': Colors.orangeAccent},
  {'name': 'Internet', 'icon': Icons.wifi, 'color': Colors.cyan},
  {'name': 'Phone', 'icon': Icons.phone, 'color': Colors.tealAccent},
  {'name': 'Vacation', 'icon': Icons.beach_access, 'color': Colors.lightBlueAccent},
  {'name': 'Dining Out', 'icon': Icons.restaurant, 'color': Colors.pinkAccent},
  {'name': 'Alcohol', 'icon': Icons.wine_bar, 'color': Colors.deepPurpleAccent},
  {'name': 'Coffee', 'icon': Icons.local_cafe, 'color': Colors.brown},
  {'name': 'Kids', 'icon': Icons.child_friendly, 'color': Colors.lime},
  {'name': 'Books', 'icon': Icons.book, 'color': Colors.orangeAccent},
  {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.purpleAccent},
  {'name': 'Savings', 'icon': Icons.savings, 'color': Colors.greenAccent},
  {'name': 'Investment', 'icon': Icons.account_balance, 'color': Colors.blueAccent},
];



Map<String, dynamic> getCategoryIconAndColor(String category) {
  return categories.firstWhere(
        (element) => element['name'] == category,
    orElse: () => {'icon': Icons.attach_money, 'color': Colors.grey}, // Default icon and color
  );
}



