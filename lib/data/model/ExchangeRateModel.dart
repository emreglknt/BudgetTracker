class ExchangeRateResponse {
  final int statusCode;
  final ExchangeRateData data;

  ExchangeRateResponse({
    required this.statusCode,
    required this.data,
  });

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      statusCode: json['status_code'],
      data: ExchangeRateData.fromJson(json['data']),
    );
  }
}

class ExchangeRateData {
  final String base;
  final String target;
  final double mid;
  final int unit;
  final DateTime timestamp;

  ExchangeRateData({
    required this.base,
    required this.target,
    required this.mid,
    required this.unit,
    required this.timestamp,
  });

  factory ExchangeRateData.fromJson(Map<String, dynamic> json) {
    return ExchangeRateData(
      base: json['base'],
      target: json['target'],
      mid: (json['mid'] as num).toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
