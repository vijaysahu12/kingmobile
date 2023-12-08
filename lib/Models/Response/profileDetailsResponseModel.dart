// Suppose you have a User model
class ProfileDetailsResponseModel {
  String name;
  String email;
  String mobile;
  DateTime dob;
  String gender;
  String city;

  ProfileDetailsResponseModel(
      {required this.name,
      required this.email,
      required this.mobile,
      required this.dob,
      required this.gender,
      required this.city});

  factory ProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponseModel(
        name: json['name'] ?? '',
        email: json['email'],
        mobile: json['mobile'],
        dob: json['dob'],
        gender: json['gender'],
        city: json['city']);
  }
}
