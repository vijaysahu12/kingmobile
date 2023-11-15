class HomeResponse {
  String id;
  String rating;

  HomeResponse({
    required this.id,
    required this.rating,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      id: json['id'] ?? '',
      rating: json['rating'] ?? '',
    );
  }
}
