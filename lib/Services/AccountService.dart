import 'package:flutter/material.dart';

import '../Helpers/dio.dart';
import '../Helpers/httpRequest.dart';
import '../Helpers/sharedPref.dart';
import '../Models/Response/profileDetailsResponseModel.dart';
import '../Helpers/ApiUrls.dart';
import '../Screens/LoginRegister/loginRegisterNew/getOtpScreen.dart';

SharedPref _sharedPref = SharedPref();

class AccountService {
  login(String mobile, String countryCode) {
    return true;
  }

  register() {}

  otpVerification(String mobile, String otp) {}

  getPersonalDetails(String Id) async {
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

  logOut(context) async {
    bool isConnected = await HttpRequestHelper.checkInternetConnection(context);
    if (isConnected) {
      _sharedPref.remove("KingUserToken");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => GetMobileOtp()),
          (route) => false);
    }
  }

  manageNotifications() {}

  void handleSignInWithEmailPassword() async {
    // if (_formKey.currentState!.validate()) {
    //   print("login button is clicked");
    //   if (_isChecked) {
    //     String _emailOrMobile = _usernameController.text;
    //     String _password = _passwordController.text;

    //     if (_emailOrMobile.isEmpty || _password.isEmpty) {
    //       setState(() {
    //         _useremailError = _emailOrMobile.isEmpty;
    //         _userPassword = _password.isEmpty;
    //       });
    //       return;
    //     }
    //     _httpHelper.checkInternetConnection(context);

    //     final apiUrl = ApiUrlConstants.baseUrl +
    //         ApiUrlConstants.login +
    //         '?userName=$_emailOrMobile&password=$_password';

    //     // final response = await http.get(Uri.parse(apiUrl));
    //     final response = await _httpHelper.getWithOutToken(apiUrl);

    //     SharedPref _sharedPref = SharedPref();

    //     if (response.statusCode == 200) {
    //       Map<String, dynamic> jsonResponse = json.decode(response.body);

    //       if (jsonResponse.containsKey('statusCode') &&
    //           jsonResponse['statusCode'] == 200) {
    //         _sharedPref.save("KingUserId", jsonResponse['data']["publicKey"]);
    //         _sharedPref.save("KingUserToken", jsonResponse['data']["token"]);
    //         _sharedPref.save(
    //             "KingUserProfileImage", jsonResponse['data']["image"]);

    //         print(jsonResponse['data']);
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => HomeScreen(),
    //           ),
    //         );
    //       } else {
    //         String errorMessage = jsonResponse['message'];
    //         showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return AlertDialog(
    //               title: Text('Login Failed'),
    //               content: Text(errorMessage),
    //               actions: <Widget>[
    //                 TextButton(
    //                   child: Text('OK'),
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                 ),
    //               ],
    //             );
    //           },
    //         );
    //       }
    //     } else {
    //       print('API Request Failed with status code: ${response.statusCode}');
    //     }
    //   }
    // }
  }
}
