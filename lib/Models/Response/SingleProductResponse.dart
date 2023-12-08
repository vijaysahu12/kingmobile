class SingleProductResponse {
  final int statusCode;
  final String? message;
  final List<Product> data;

  SingleProductResponse({
    required this.statusCode,
    this.message,
    required this.data,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
      data:
          (json['data'] as List).map((item) => Product.fromJson(item)).toList(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  // final double priceAfterDiscount;
  // final int discount;
  final String rating;
  // final bool liked;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    // required this.priceAfterDiscount,
    // required this.discount,
    required this.rating,
    // required this.liked,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      // priceAfterDiscount: json['priceAfterDiscount']?.toDouble() ?? 0.0,
      // discount: json['discount'] ?? 0,
      rating: json['rating'] ?? '',
      // liked: json['liked'] == null ? false : json['liked'] as bool,
    );
  }
}
