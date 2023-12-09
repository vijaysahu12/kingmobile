import 'dart:convert';

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
  final String name;
  final String description;
  final String category;
  final double price;
  final String rating;
  final List<ExtraBenefit> extraBenefits;

  Product({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.extraBenefits,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ExtraBenefit> parseExtraBenefits(dynamic jsonValue) {
      if (jsonValue is List) {
        return jsonValue.map((item) => ExtraBenefit.fromJson(item)).toList();
      }
      return [];
    }

    return Product(
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        price: json['price']?.toDouble() ?? 0.0,
        rating: json['rating'] ?? '',
        extraBenefits: parseExtraBenefits(
          json['extraBenefits'] != null
              ? jsonDecode(json['extraBenefits'])
              : [],
        ));
  }
}

class ExtraBenefit {
  final String subscriptionName;
  final int months;
  final String name;
  final String description;

  ExtraBenefit({
    required this.subscriptionName,
    required this.months,
    required this.name,
    required this.description,
  });

  factory ExtraBenefit.fromJson(Map<String, dynamic> json) {
    return ExtraBenefit(
      subscriptionName: json['SubscriptionName'] ?? '',
      months: json['Months'] ?? 0,
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
    );
  }
}
