// Suppose you have a User model
class ProductResponseModel {
  String id;
  String name;
  String category;
  String description;
  String overAllRating;
  String userRating;
  bool userHasHeart;
  double heartsCount;
  bool liked;
  double price;
  String imageUrl;
  ProductResponseModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.userHasHeart,
      required this.heartsCount,
      required this.overAllRating,
      required this.userRating,
      required this.liked,
      required this.price,
      required this.imageUrl});

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
        overAllRating: json['overAllRating'] != null
            ? json['overAllRating'].toString()
            : '',
        userRating:
            json['userRating'] != null ? json['userRating'].toString() : '',
        price: (json['price'] ?? 0).toDouble(), // Handle conversion to double
        imageUrl: json['imageUrl'] ?? '');
  }
}
