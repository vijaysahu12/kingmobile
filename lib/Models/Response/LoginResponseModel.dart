class LoginResponse {
  String id;
  String message;
  String statusCode;

  LoginResponse({
    required this.id,
    required this.message,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? '',
    );
  }
}
