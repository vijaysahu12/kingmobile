// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:kraapp/Screens/all_screens.dart';
// import 'package:kraapp/Screens/Login_Info/registerScreen.dart';
// import 'package:kraapp/Screens/all_screens.dart';

import 'package:kraapp/app_color.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final PhoneAuthCredential credential;
  const OtpVerificationScreen(
      {required this.verificationId, required this.credential, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreen();
}

class _OtpVerificationScreen extends State<OtpVerificationScreen> {
  List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  void _otpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).nextFocus(); // Move focus to the next TextField
      }
    }
  }

  void signInWithOtp(BuildContext context) async {
    print("signInWithOtp function called");
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(widget.credential);
      User user = userCredential.user!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                backgroundColor: AppColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
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
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Seshadri Kaku',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            'Email Id',
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
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Seshadri@gmail.com',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            ),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '6309373318',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Hyderabad',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                        onChanged: handleRadioValueChange,
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
                                        onChanged: handleRadioValueChange,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(user),
                                    ));
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
          );
        },
      );
    } catch (e) {
      print("Error signing in with OTP: $e");
    }
  }

  String selectedGender = '';

  void handleRadioValueChange(String? value) {
    setState(() {
      selectedGender = value!;
    });
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
