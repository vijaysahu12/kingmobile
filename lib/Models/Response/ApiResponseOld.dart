class ApiResponseOld<T> {
  bool success;
  String message;
  T data;

  ApiResponseOld({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponseOld.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponseOld(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
    );
  }
}
