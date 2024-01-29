class OtpVerificationResponse {
  final int statusCode;
  final String message;
  final Data data;

  OtpVerificationResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'][0] ?? {}),
    );
  }
}

class Data {
  final String publicKey;
  // final String name;
  final String profileImage;
  final String OneTimePassword;
  final String token;

  Data(
      {required this.publicKey,
      // required this.name,
      required this.profileImage,
      required this.token,
      required this.OneTimePassword});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        publicKey: json['publicKey'] ?? '',
        //  name: json['name'] ?? '',
        profileImage: json['profileImage'] ?? '',
        token: json['token'] ?? '',
        OneTimePassword: json["oneTimePassword"] ?? '');
  }
}
