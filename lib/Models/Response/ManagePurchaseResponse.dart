class ManagePurchaseResponse {
  final int statusCode;
  final String message;
  final String data;

  const ManagePurchaseResponse(
      {required this.statusCode, required this.message, required this.data});

  factory ManagePurchaseResponse.fromJson(Map<String, dynamic> json) {
    return ManagePurchaseResponse(
        data: json['data'] ?? '',
        message: json['messgae'],
        statusCode: json['statusCode']);
  }
}
