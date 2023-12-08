class HomeResponse {
  String? id;
  double? price;

  HomeResponse({
    required this.id,
    required this.price,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      //     id: json['id'] ?? '',
      id: json['id']?.toString() ?? '',
      price: json['price'] ?? '',
    );
  }
}
