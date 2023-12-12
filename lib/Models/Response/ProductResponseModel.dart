// Suppose you have a User model
class ProductResponseModel {
  String id;
  String name;
  String category;
  String description;
  String raiting;
  bool userHasHeart;
  double heartsCount;
  bool liked;
  double price;

  ProductResponseModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.userHasHeart,
      required this.heartsCount,
      required this.raiting,
      required this.liked,
      required this.price});

  // factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
  //   return ProductResponseModel(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     liked: json['liked'],
  //     category: json['category'] ?? '',
  //     description: json['description'],
  //     raiting: json['rating'],
  //     //favourite: json['favourite'],
  //     price: json['price'],
  //   );
  // }
  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      liked: json['liked'] ?? false,
      category: json['category'] ?? false,
      description: json['description'] ?? '',
      userHasHeart: json['userHasHeart'] ?? '',
      heartsCount: (json['heartsCount'] ?? 0).toDouble(),
      raiting: json['rating'] != null ? json['rating'].toString() : '',
      price: (json['price'] ?? 0).toDouble(), // Handle conversion to double
    );
  }
}
