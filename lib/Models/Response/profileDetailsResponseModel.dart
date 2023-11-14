// Suppose you have a User model
class ProfileDetailsResponseModel {
  String id;
  String name;
  String email;
  String mobile;
  DateTime dob;
  String gender;

  ProfileDetailsResponseModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.mobile,
      required this.dob,
      required this.gender});

  factory ProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      mobile: json['mobile'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }
}
