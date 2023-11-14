import 'package:flutter/material.dart';
import 'package:kraapp/main.dart';

import '../../Constants/app_color.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreen();
}

class _VerificationScreen extends State<VerificationScreen> {
  List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  void _showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 130.0),
              height: 500,
              child: Dialog(
                backgroundColor: AppColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'images/done_logo.jpg',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightShadow),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '  You have Successfully Completed \n your Registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightShadow),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green.withOpacity(0.6),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 6), // Bottom shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: AppColors.cyan,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 80),
                              elevation: 25,
                              shadowColor: AppColors.green.withOpacity(0.3)),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                                color: AppColors.dark,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                        ),
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
  }

  void _otpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).nextFocus(); // Move focus to the next TextField
      } else {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 18,
                        color: AppColors.dark,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/verification_logo.jpg',
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        'Verification',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Enter the 4 Digit Code sent to Your Phone \nNumber.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                          fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 60,
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
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'I Didn\'t Receive the Code.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue),
                    ),
                  ),
                ],
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
                            setState(() {
                              _showPopUp(context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 80),
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
            ],
          ),
        ),
      ),
    );
  }
}
