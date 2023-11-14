import '../Helpers/dio.dart';
import '../Models/Response/profileDetailsResponseModel.dart';
import '../Helpers/ApiUrls.dart';

class ProfileSetting {
  getPersonalDetails() async {
    ApiService _apiService = ApiService();

    ApiResponse<ProfileDetailsResponseModel> response =
        await _apiService.get<ProfileDetailsResponseModel>(
      ApiUrlConstants.getPersonalDetails,
      (json) => ProfileDetailsResponseModel.fromJson(json),
    );

    if (response.statusCode == 200) {
      print('Request successful. User Name: ${response.data.name}');
    } else {
      print('Request failed. Error message: ${response.message}');
    }
  }

  manageProfileImage() {}
  managePersonalDetails() async {}

  logOut() {}
  manageNotifications() {}
}
