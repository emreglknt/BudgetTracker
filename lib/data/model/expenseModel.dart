class Expense{
  final double price;
  final String category;
  final String date;

  Expense({
    required this.price,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      price: json['price'].toDouble(),
      category: json['category'],
      date: json['date'],
    );
  }


}