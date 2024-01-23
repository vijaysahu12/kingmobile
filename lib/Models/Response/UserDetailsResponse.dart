class UserDetailsResponse {
  final String fullName;
  final String emailId;
  final String mobile;
  final String city;
  final String gender;
  final DateTime dob;
  final String publicKey;
  final String profileImage;

  UserDetailsResponse({
    required this.fullName,
    required this.emailId,
    required this.mobile,
    required this.city,
    required this.gender,
    required this.dob,
    required this.publicKey,
    required this.profileImage,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
      fullName: json['fullName'] ?? '',
      emailId: json['emailId'] ?? '',
      mobile: json['mobile'] ?? '',
      city: json['city'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : DateTime.now(),
      publicKey: json['publicKey'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
