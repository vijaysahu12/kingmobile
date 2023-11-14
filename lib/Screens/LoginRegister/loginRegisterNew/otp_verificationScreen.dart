import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:kraapp/Screens/all_screens.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/app_color.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final int? resendToken;
  const OtpVerificationScreen(
      {required this.verificationId, required this.resendToken, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreen();
}

class _OtpVerificationScreen extends State<OtpVerificationScreen> {
  List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // bool _usernameError = false;
  // bool _useremailError = false;
  // bool _userMobileError = false;
  // bool _cityErrorController = false;

  void _otpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).nextFocus();
      } else {}
    }
  }

  String selectedGender = '';

  void handleRadioValueChange(String? value) {
    if (value != null) {
      setState(() {
        selectedGender = value;
      });
    }
    ;
  }

  Future<void> createToken() async {
    final pref = await SharedPreferences.getInstance();

    String token = generateToken(32);

    await pref.setString('token', token);
    print(token);
  }

  String generateToken(int length) {
    final random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  void signInWithOtp(BuildContext context) async {
    print("signInWithOtp function called");

    try {
      String smsCode =
          _otpControllers.map((controller) => controller.text).join();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      //UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      // User user = userCredential.user!;

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
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      borderRadius: BorderRadius.circular(10),
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Radio(
                                          value: 'Male',
                                          groupValue: selectedGender,
                                          onChanged: (value) {
                                            handleRadioValueChange(value);
                                          },
                                          activeColor: AppColors.primaryColor,
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
                                      borderRadius: BorderRadius.circular(10),
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Radio(
                                          value: 'Female',
                                          groupValue: selectedGender,
                                          onChanged: (value) {
                                            handleRadioValueChange(value);
                                          },
                                          activeColor: AppColors.primaryColor,
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    createToken();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
    } catch (e) {
      print("Error signing in with OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
          top: 400,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.lightShadow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      onChanged: (value) => _otpChanged(index, value),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  );
                }),
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

                          signInWithOtp(context);
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
    );
  }
}
