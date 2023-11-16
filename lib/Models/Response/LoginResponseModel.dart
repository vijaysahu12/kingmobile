class HomeResponse {
  String id;
  String message;
  String statusCode;

  HomeResponse({
    required this.id,
    required this.message,
    required this.statusCode,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? '',
    );
  }
}
