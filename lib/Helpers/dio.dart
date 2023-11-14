import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<ApiResponse<T>> get<T>(
      String url, T Function(dynamic) fromJsonT) async {
    try {
      Response response = await _dio.get(url);

      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (error) {
      print("Error: $error");
      return ApiResponse<T>(
        statusCode: 200,
        message: "An error occurred during the request.",
        data: fromJsonT(<String, dynamic>{}),
      );
    }
  }

  // Add more methods for other HTTP verbs (post, put, delete, etc.) as needed
}

class ApiResponse<T> {
  int statusCode;
  String message;
  T data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      statusCode: json['statusCode'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
    );
  }
}
