class ChartModel{
  final double price;
  final String category;


  ChartModel({
    required this.price,
    required this.category,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      price: json['price'].toDouble(),
      category: json['category'],
    );
  }


}