import 'dart:convert';
import 'package:kraapp/Screens/LoginRegister/loginRegisterNew/userDataDialog.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kraapp/Helpers/ApiUrls.dart';
import 'package:kraapp/Screens/Common/refreshtwo.dart';
// import 'package:kraapp/Screens/all_screens.dart';

import '../../../Helpers/sharedPref.dart';
import '../../../Models/Response/OtpVerficationResponse.dart';
import '../../Common/useSharedPref.dart';
import '../../Constants/app_color.dart';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final int? resendToken;
  final String mobileNumber;
  final String deviceType;
  final String countryCode;
  final String? fcmToken;

  const OtpVerificationScreen({
    required this.verificationId,
    required this.resendToken,
    required this.mobileNumber,
    required this.deviceType,
    required this.countryCode,
    required this.fcmToken,
    super.key,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreen();
}

class _OtpVerificationScreen extends State<OtpVerificationScreen> {
  List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  // TextEditingController _smsController = TextEditingController();
  // ignore: unused_field
  String _enteredOTP = '';

  String _smsCode = "";
  // final _formKey = new GlobalKey<FormState>();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  String? selectedGender;
  StateSetter? _setState;

  SharedPref _sharedPref = SharedPref();
  UsingSharedPref usingSharedPref = UsingSharedPref();
  UsingHeaders usingHeaders = UsingHeaders();

  void _handleAutoFilledOtp(String otp) {
    signInWithOtp(context, otp);
  }

  void _otpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 6) {
        setState(() {
          _enteredOTP =
              _otpControllers.map((controller) => controller.text).join();
        });
        if (index < 5) {
          FocusScope.of(context).nextFocus();
        }
      }
    } else {
      // Check if it's the first field or a deletion in any other field
      if (index == 0 || (index > 0 && _otpControllers[index].text.isEmpty)) {
        FocusScope.of(context).previousFocus();
      }
      // Clear the current field
      _otpControllers[index].text = '';
    }
    _handleAutoFilledOtp(_enteredOTP);
  }

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // void configureFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("Received a notification: ");
  //     print(messaging);
  //   });
  // }

  // void _requestSmsPermission() async {
  //   var status = await Permission.sms.status;
  //   if (!status.isGranted) {
  //     await Permission.sms.request();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _listenForSms();
    _userData();
  }

  void _listenForSms() async {
    // _requestSmsPermission();
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void _userData() async {
    String mobile = await _sharedPref.read("UserProfileMobile");
    setState(() {
      _mobileController.text = mobile.replaceAll('"', '');
    });
  }

  Future<void> postUserData(userData) async {
    final jwtToken = await usingSharedPref.getJwtToken();
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);
    final String apiUrl = '${ApiUrlConstants.ManageUserDetails}';

    print(userData);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['statusCode'] == 200) {
          print("Data is updated successfully!");
        } else {
          print(
              'Failed to update data: ${responseBody['statusCode']}, ${responseBody['message']}');
        }
      } else {
        print('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  @override
  void setState(VoidCallback fn) {
    // invoke dialog setState to refresh dialog content when need
    _setState?.call(fn);
    super.setState(fn);
  }

  void signInWithOtp(BuildContext context, String smsCode) async {
    print("signInWithOtp function called");
    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: widget.verificationId, smsCode: smsCode);
      // UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      // print(userCredential);
      print('OTP verification successful!');
      String deviceType = widget.deviceType;
      String? firebaseToken = widget.fcmToken;
      String countryCode = widget.countryCode;
      final apiUrl = ApiUrlConstants.otpLoginVerfication +
          '?mobileNumber=${widget.mobileNumber}&FirebaseFcmToken=$firebaseToken&deviceType=$deviceType&countryCode=$countryCode';
      print(apiUrl);
      final response = await http.post(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response);
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final OtpVerificationResponse vv =
            OtpVerificationResponse.fromJson(responseBody);

        _sharedPref.save(SessionConstants.UserKey, vv.data.publicKey);
        _sharedPref.save(SessionConstants.Token, vv.data.token);
        _sharedPref.save(
            SessionConstants.UserProfileImage, vv.data.profileImage);

        int statusCode = responseBody['statusCode'];

        if (statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                _setState = setState;
                return Center(
                    child: UserDataDialog(
                  onRegister: (
                    _fullName,
                    _email,
                    _mobile,
                    _city,
                    _gender,
                  ) async {
                    String? fullName = _fullName;
                    String? email = _email;
                    String? mobile = _mobile;
                    String? city = _city;
                    _sharedPref.save("KingUserProfileName", fullName);
                    _sharedPref.save("KingUserProfileEmail", email);
                    _sharedPref.save("KingUserProfileMobile", mobile);
                    _sharedPref.save("KingUserProfileCity", city);
                    _sharedPref.save("KingUserProfileGender", _gender);

                    print(fullName);
                    print(email);
                    print(mobile);
                    print(city);
                    print(_gender);
                    // configureFirebaseMessaging();

                    Map<String, String> userData = {
                      "fullName": fullName,
                      "emailId": email,
                      "mobile": mobile,
                      "city": city,
                      "gender": _gender,
                      "dob": "08-08-20"
                    };

                    postUserData(userData);
                  },
                  mobile: widget.mobileNumber,
                ));
              });
            },
          );
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'invalid-verification-code') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid OTP'),
              content: Text('The entered OTP is incorrect. Please try again.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshHelper.buildRefreshIndicator(
        onRefresh: RefreshHelper.defaultOnRefresh,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(
            top: 400,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                  currentCode: _smsCode,
                  // controller: _smsController,
                  onCodeSubmitted: (code) {},
                  onCodeChanged: (code) {
                    setState(() {
                      _smsCode = code ?? ""; // Update the _smsCode variable
                    });
                    if (code?.length == 6) {
                      print("Auto-filled OTP: $_smsCode");
                      FocusScope.of(context).requestFocus(FocusNode());
                      signInWithOtp(context, _smsCode);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            print("Verify button pressed");

                            signInWithOtp(
                                context,
                                _otpControllers
                                    .map((controller) => controller.text)
                                    .join());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 100),
                            elevation: 30,
                          ),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                                color: AppColors.lightShadow,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        'Not you?.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.dark,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Switch Account',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
