class UserDetailsResponse {
  final String fullName;
  final String emailId;
  final String mobile;
  final String city;
  final String gender;
  DateTime dob;

  UserDetailsResponse(
      {required this.fullName,
      required this.city,
      required this.dob,
      required this.emailId,
      required this.gender,
      required this.mobile});

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
        fullName: json['fullName'] ?? '',
        city: json['city'] ?? '',
        dob: DateTime.parse(json['dob']),
        emailId: json['emailId'] ?? '',
        gender: json['gender'] ?? '',
        mobile: json['mobile'] ?? '');
  }
}
