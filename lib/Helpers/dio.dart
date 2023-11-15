import 'package:dio/dio.dart';
import 'package:kraapp/Helpers/ApiUrls.dart';
import 'package:kraapp/Helpers/sharedPref.dart';

class ApiService {
  final Dio _dio = Dio();
  final SharedPref _session = new SharedPref();
  // Constructor to initialize Dio with common configurations
  ApiService() {
    this.getHeaders();
  }
  getHeaders() async {
    final YOUR_ACCESS_TOKEN = _session.read(SessionConstants.Token);
    _dio.options.headers = {
      'Content-Type': 'application/json', // Add your headers here
      'Authorization': 'Bearer ' + YOUR_ACCESS_TOKEN,
    };
  }

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

  Future<ApiResponse<T>> getWithList<T>(
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

class ApiServiceTwo {
  final SharedPref _session = new SharedPref();
  final Dio _dio = Dio();

  ApiServiceTwo() {
    this.getHeaders();
  }
  getHeaders() async {
    final YOUR_ACCESS_TOKEN = await _session.read(SessionConstants.Token);

    _dio.options.headers = {
      'Content-Type': 'application/json', // Add your headers here
      'Authorization': 'Bearer ' + YOUR_ACCESS_TOKEN,
    };
  }

  Future get(String url) async {
    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }
}
