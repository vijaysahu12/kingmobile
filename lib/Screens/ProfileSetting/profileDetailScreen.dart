import 'package:flutter/material.dart';

// import 'package:kraapp/Screens/Login_Info/getotp_verification.dart';
import 'package:kraapp/Screens/ProfileSetting/notifications.dart';
import 'package:kraapp/Screens/ProfileSetting/personalDetails.dart';
import 'package:kraapp/Screens/ProfileSetting/settings.dart';
//import 'package:kraapp/Screens/login_and_register/login_screen.dart';

// import 'package:kraapp/Screens/login_and_register/login_screen.dart';

import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:kraapp/Services/AccountService.dart';

// import 'package:sliding_switch/sliding_switch.dart';

import '../../Helpers/sharedPref.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformation();
}

class _PersonalInformation extends State<PersonalInformation> {
  SharedPref _sharedPref = SharedPref();

  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    String fullName = await _sharedPref.read("KingUserProfileName") ?? '';
    String email = await _sharedPref.read("KingUserProfileEmail") ?? '';

    setState(() {
      _userName = fullName.replaceAll('"', '');
      _userEmail = email.replaceAll('"', '');
    });
  }

  bool isSwtitched = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: AppColors.lightShadow,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'images/person_logo.png',
                        ),
                        radius: 25,
                        backgroundColor: AppColors.lightShadow,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName.isNotEmpty ? _userName : 'User Name',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'poppins'),
                          ),
                          Text(
                            _userEmail.isNotEmpty
                                ? _userEmail
                                : 'UserEmail@gmail.com',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'poppins'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalDetails(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.lightShadow,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Personal details',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.grey,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.lightShadow,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: AppColors.grey,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.grey,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.lightShadow,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: AppColors.grey,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.grey,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => AccountService().logOut(context),
              // _sharedPref.remove("KingUserToken");
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => GetMobileOtp()),
              //     (route) => false);

              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.lightShadow,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Icon(
                      Icons.power_settings_new_outlined,
                      color: AppColors.grey,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.grey,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: AppColors.lightShadow,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.nightlight_outlined,
                        color: AppColors.grey,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Mode',
                        style: TextStyle(
                            color: AppColors.grey,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: AppColors.primaryColor, width: 1)),
                        child: Row(
                          children: [
                            // SlidingSwitch(
                            //   value: false,
                            //   onChanged: (bool value) {
                            //     setState(() {
                            //       isSwtitched = value;
                            //     });
                            //   },
                            //   onTap: () {},
                            //   onDoubleTap: () {},
                            //   onSwipe: () {},
                            //   height: 25,
                            //   width: 50,
                            //   animationDuration: Duration(milliseconds: 200),
                            //   textOn: '',
                            //   textOff: '',
                            //   buttonColor: isSwtitched
                            //       ? AppColors.primaryColor
                            //       : AppColors.cyan,
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
