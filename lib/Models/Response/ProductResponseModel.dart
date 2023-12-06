// Suppose you have a User model
class ProductResponseModel {
//  String id;
  String name;
  String category;
  String description;
  String raiting;
  bool liked;
  double price;

  ProductResponseModel(
      {
      //required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.raiting,
      required this.liked,
      required this.price});

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      // id: json['id'] ?? '',
      name: json['name'] ?? '',
      liked: json['liked'],
      category: json['category'] ?? '',
      description: json['description'],
      raiting: json['rating'],
      //favourite: json['favourite'],
      price: json['price'],
    );
  }
}
