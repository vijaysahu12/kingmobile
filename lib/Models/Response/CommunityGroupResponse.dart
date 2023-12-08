class CommunityGroupResponse {
  String id;
  String name;
  String description;
  // String image;

  CommunityGroupResponse({
    required this.id,
    required this.name,
    required this.description,
    // required this.image,
  });

  // factory CommunityGroupResponse.fromJson(Map<String, dynamic> json) {
  //   return CommunityGroupResponse(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     description: json['description'],
  //     // image: json['image'] ?? '',
  //   );
  // }
  factory CommunityGroupResponse.fromJson(Map<String, dynamic> json) {
    return CommunityGroupResponse(
      id: json['id'] != null ? json['id'].toString() : '',
      name: json['name'] != null ? json['name'].toString() : '',
      description:
          json['description'] != null ? json['description'].toString() : '',
    );
  }
}
