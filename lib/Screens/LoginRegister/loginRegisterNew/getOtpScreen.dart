import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/LoginRegister/loginRegisterNew/otp_verificationScreen.dart';

import '../../../Helpers/httpRequest.dart';
import '../../../Helpers/ApiUrls.dart';
import '../../../Helpers/sharedPref.dart';
import '../../Constants/app_color.dart';

class GetMobileOtp extends StatefulWidget {
  const GetMobileOtp({super.key});

  @override
  State<GetMobileOtp> createState() => _GetMobileOtp();
}

class _GetMobileOtp extends State<GetMobileOtp> {
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  HttpRequestHelper _httpHelper = HttpRequestHelper();
  // SharedPref _sharedPref = SharedPref();
  // AccountService _accountService = new AccountService();

  Future<void> signInWithMobile(BuildContext context) async {
    signInWithOtp();
    //signInWithoutMobileOtp();
  }

  // String selectedGender = '';
  // void handleRadioValueChange(String? value) {
  //   if (value != null) {
  //     setState(() {
  //       selectedGender = value;
  //       _sharedPref.save("KingUserProfileGender", selectedGender);
  //     });
  //   }
  // }

  Future<String?> getImei() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return 'Device Type is Android  and AndroidID: ${androidInfo.androidId}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return 'Device Type is IOS & IosId ${iosInfo.identifierForVendor}';
      }
    } catch (e) {
      print('Error getting IMEI: $e');
      return null;
    }
    return null;
  }

  signInWithOtp() async {
    //final response = _accountService.login( phoneNumberController.text, countryCodeController.text);
    String _emailOrMobile = phoneNumberController.text;
    String _countryCode = '91';
    _httpHelper.checkInternetConnection(context);

    final apiUrl = ApiUrlConstants.otpLogin +
        '?mobileNumber=$_emailOrMobile&countryCode=$_countryCode';
    // final response = await http.get(Uri.parse(apiUrl));
    final response = await _httpHelper.getWithOutToken(apiUrl);
    if (response.statusCode == 200) {
      SharedPref _sharedPref = SharedPref();
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('statusCode') &&
          jsonResponse['statusCode'] == 200) {
        _sharedPref.save("UserProfileMobile", _emailOrMobile);
        _sharedPref.save("UserProfileMobileOTP", jsonResponse['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
                // verificationId: 'verificationId',
                // resendToken: 1,
                ),
          ),
        );
      } else {
        //ToDo: Try Again invalid mobile number
      }
    }
  }

  verifyMobileOtp() {
    //ToDO: if verification confirmed then go to profile update screen else stay there with try again message
  }

  signInWithOtpOld() async {
    String? imei = await getImei();
    String phoneNumber = "+91" + phoneNumberController.text;

    if (imei != null) {
      print('IMEI: $imei');
    } else {
      print('Failed to get IMEI');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential cred) async {
        print('verificationCompleted $cred');
      },
      verificationFailed: (FirebaseAuthException ex) {
        print("verification Failed");
        print('verificationFailed---> ${ex}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        print("code sent");
        print('codeSent $verificationId');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
                // verificationId: verificationId,
                // resendToken: resendToken,
                ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(' $verificationId');
      },
    );
  }

  signInWithoutMobileOtp() async {
    if (true) {
      print("login button is clicked");
      if (true) {
        //String _emailOrMobile = "+91" + phoneNumberController.text;
        String _emailOrMobile = phoneNumberController.text;
        String _password = '123456';

        // if (_emailOrMobile.isEmpty || _password.isEmpty) {
        //   setState(() {
        //     _useremailError = _emailOrMobile.isEmpty;
        //     _userPassword = _password.isEmpty;
        //   });
        //   return;
        // }
        _httpHelper.checkInternetConnection(context);

        final apiUrl = ApiUrlConstants.login +
            '?userName=$_emailOrMobile&password=$_password';
        // final response = await http.get(Uri.parse(apiUrl));
        final response = await _httpHelper.getWithOutToken(apiUrl);
        if (response.statusCode == 200) {
          SharedPref _sharedPref = SharedPref();

          Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.containsKey('statusCode') &&
              jsonResponse['statusCode'] == 200) {
            _sharedPref.save(
                SessionConstants.UserKey, jsonResponse['data']["publicKey"]);
            _sharedPref.save(
                SessionConstants.Token, jsonResponse['data']["token"]);
            _sharedPref.save(SessionConstants.UserProfileImage,
                jsonResponse['data']["image"]);

            print(jsonResponse['data']);
          } else {
            String errorMessage = jsonResponse['message'];
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enter valid Mobile'),
                  content: Text(errorMessage),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('API Request Failed with status code: ${response.statusCode}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 400),
          child: Column(
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter mobile number',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w600),
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                      countryListTheme: CountryListThemeData(
                                        bottomSheetHeight: 400,
                                      ),
                                      context: context,
                                      onSelect: (value) {
                                        setState(() {
                                          selectedCountry = value;
                                        });
                                      });
                                },
                                child: Text(
                                  "${selectedCountry.flagEmoji}  +${selectedCountry.phoneCode}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.dark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'By proceeding up, I am agreeing to our ',
                              style: TextStyle(
                                  color: AppColors.dark,
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          TextSpan(
                            text: 'Terms & Conditions and Privacy Policy.',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryColor,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        signInWithMobile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        elevation: 20,
                      ),
                      child: Text(
                        'Proceed Ahead',
                        style: TextStyle(
                          color: AppColors.lightShadow,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 40,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'built with love',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'for indians who love to invest & trade',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}