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
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String rating;
  late bool isHeart;
  final List<ExtraBenefit> extraBenefits;
  final List<ContentResponse> content;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isHeart,
    required this.price,
    required this.rating,
    required this.extraBenefits,
    required this.content,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ExtraBenefit> parseExtraBenefits(dynamic jsonValue) {
      if (jsonValue is List) {
        return jsonValue.map((item) => ExtraBenefit.fromJson(item)).toList();
      }
      return [];
    }

    List<ContentResponse> parseContentResponse(dynamic jsonValue) {
      if (jsonValue is List) {
        return jsonValue.map((item) => ContentResponse.fromJson(item)).toList();
      }
      return [];
    }

    return Product(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        price: json['price']?.toDouble() ?? 0.0,
        rating: json['rating'] ?? '',
        isHeart: json['isHeart'],
        extraBenefits: parseExtraBenefits(
          json['extraBenefits'] != null
              ? jsonDecode(json['extraBenefits'])
              : [],
        ),
        content: parseContentResponse(
          json['content'] != null ? jsonDecode(json['content']) : [],
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

class ContentResponse {
  final int Id;
  final int ProductId;
  final String Title;
  final String Description;
  final String ThumbnailImage;
  final String ListImage;
  final String Attachment;

  const ContentResponse({
    required this.Id,
    required this.Attachment,
    required this.Description,
    required this.ListImage,
    required this.ProductId,
    required this.ThumbnailImage,
    required this.Title,
  });

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
        Id: json['Id'] ?? 0,
        ProductId: json['ProductId'] ?? 0,
        Attachment: json['Attachment'] ?? '',
        Description: json['Description'] ?? '',
        ListImage: json['ListImage'] ?? '',
        ThumbnailImage: json['ThumbnailImage'] ?? '',
        Title: json['Title'] ?? '');
  }
}
