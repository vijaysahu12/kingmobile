class GetTopGainers {
  final String stockName;
  final String exchange;
  final double ltp;
  final double price;

  const GetTopGainers(
      {required this.exchange,
      required this.ltp,
      required this.price,
      required this.stockName});

  factory GetTopGainers.fromJson(Map<String, dynamic> json) {
    return GetTopGainers(
        exchange: json['exchange'] ?? '',
        ltp: json['ltp'] ?? 0.0,
        price: json['price'] ?? 0.0,
        stockName: json['stockName'] ?? '');
  }
}
