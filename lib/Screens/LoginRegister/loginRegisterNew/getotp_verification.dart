import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/LoginRegister/loginRegisterNew/otp_verificationScreen.dart';
import 'package:kraapp/Screens/all_screens.dart';
import 'package:kraapp/Services/AccountService.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  HttpRequestHelper _httpHelper = HttpRequestHelper();
  SharedPref _sharedPref = SharedPref();

  Future<void> signInWithMobile(BuildContext context) async {
    //this.signInWithOtp();
    signInWithoutMobileOtp();
  }

  String selectedGender = '';
  AccountService _accountService = new AccountService();

  void handleRadioValueChange(String? value) async {
    setState(() {
      selectedGender = value!;
    });
    await _sharedPref.save("selectedGender", value);
  }

  signInWithOtp() async {
    final response = _accountService.login(
        phoneNumberController.text, countryCodeController.text);

    if (response) {
      //ToDo: Pop OTP Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            verificationId: 'verificationId',
            resendToken: 1,
          ),
        ),
      );
    } else {
      //ToDo: Try Again invalid mobile number
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
              verificationId: verificationId,
              resendToken: resendToken,
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
            _sharedPref.save("KingUserId", jsonResponse['data']["publicKey"]);
            _sharedPref.save("KingUserToken", jsonResponse['data']["token"]);
            _sharedPref.save(
                "KingUserProfileImage", jsonResponse['data']["image"]);

            print(jsonResponse['data']);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SingleChildScrollView(
                    child: Dialog(
                      backgroundColor: AppColors.lightShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightShadow,
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //     color: _usernameError
                                      //         ? Colors.red
                                      //         : AppColors.lightShadow),
                                    ),
                                    child: TextFormField(
                                      controller: _nameController,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Your Name',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            // _usernameError = true;
                                          });

                                          return 'This field is required';
                                        } else if (value.length < 4) {
                                          setState(() {
                                            //  _usernameError = true;
                                          });

                                          return 'Enter Full Name';
                                        } else {
                                          // _usernameError = false;
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email Id *',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors
                                          .cyan, // Customize the color if needed
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightShadow,
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: _useremailError
                                      //       ? Colors.red
                                      //       : AppColors.lightShadow,
                                      // ),
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Email Id',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          //_useremailError = true;
                                          return 'This field is required';
                                        } else if (!RegExp(r'^\d{10}$')
                                                .hasMatch(value) &&
                                            !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                                .hasMatch(value)) {
                                          //  _useremailError = true;
                                          return 'Enter Valid Email';
                                        } else {
                                          //  _useremailError = false;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightShadow,
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: _userMobileError
                                      //       ? Colors.red
                                      //       : AppColors.lightShadow,
                                      // ),
                                    ),
                                    child: TextFormField(
                                      controller: _mobileController,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Mobile Number',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          // _userMobileError = true;
                                          return 'This field is required';
                                        } else if (!RegExp(r'^\d{10}$')
                                            .hasMatch(value)) {
                                          //_userMobileError = true;
                                          return 'Enter 10digits valid number';
                                        } else {
                                          // _userMobileError = false;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'City',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors
                                          .cyan, // Customize the color if needed
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightShadow,
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: _cityErrorController
                                      //       ? Colors.red
                                      //       : AppColors
                                      //           .lightShadow, // Change border color based on error
                                      // ),
                                    ),
                                    child: TextFormField(
                                      controller: _cityController,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Current City',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          //  _cityErrorController = true;
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.lightShadow,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Male',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'poppins',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Radio(
                                                value: 'Male',
                                                groupValue: selectedGender,
                                                onChanged: (value) {
                                                  handleRadioValueChange(value);
                                                },
                                                activeColor:
                                                    AppColors.primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightShadow,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Female',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'poppins',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Radio(
                                                value: 'Female',
                                                groupValue: selectedGender,
                                                onChanged: (value) {
                                                  handleRadioValueChange(value);
                                                },
                                                activeColor:
                                                    AppColors.primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String fullName = _nameController.text;
                                        String email = _emailController.text;
                                        String mobile = _mobileController.text;
                                        String city = _cityController.text;
                                        if (_formKey.currentState!.validate()) {
                                          _sharedPref.save(
                                              "KingUserProfileName", fullName);
                                          _sharedPref.save(
                                              "KingUserProfileEmail", email);
                                          _sharedPref.save(
                                              "KingUserProfileMobile", mobile);
                                          _sharedPref.save(
                                              "KingUserProfileCity", city);

                                          print(fullName);
                                          print(email);
                                          print(mobile);
                                          print(city);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(),
                                              ));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: AppColors.cyan,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 80,
                                        ),
                                        elevation: 20,
                                      ),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          color: AppColors.dark,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomeScreen(),
            //   ),
            // );
          } else {
            String errorMessage = jsonResponse['message'];
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Failed'),
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
                        ),
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
