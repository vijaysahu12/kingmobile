class CommunityResponseModel {
  String id;
  String image;

  CommunityResponseModel({
    required this.id,
    required this.image,
  });

  factory CommunityResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityResponseModel(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
