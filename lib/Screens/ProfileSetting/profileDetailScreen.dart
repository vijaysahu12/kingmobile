import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kraapp/Screens/ProfileSetting/myBucket.dart';

import 'package:kraapp/Screens/ProfileSetting/notifications.dart';
import 'package:kraapp/Screens/ProfileSetting/personalDetails.dart';
import 'package:kraapp/Screens/ProfileSetting/settings.dart';
import 'package:http/http.dart' as http;

import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:kraapp/Services/AccountService.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/UserDetailsResponse.dart';
import '../Common/app_bar.dart';
import '../Common/refreshtwo.dart';
import '../Common/useSharedPref.dart';
// import '../Common/refresh.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformation();
}

class _PersonalInformation extends State<PersonalInformation> {
  SharedPref _sharedPref = SharedPref();
  bool isSwtitched = false;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<UserDetailsResponse>?> GetUserDetails() async {
    try {
      String userKey = await _sharedPref.read(SessionConstants.UserKey);
      String mobileKey = userKey.replaceAll('"', '');
      UsingSharedPref usingSharedPref = UsingSharedPref();
      final jwtToken = await usingSharedPref.getJwtToken();
      Map<String, String> headers =
          usingHeaders.createHeaders(jwtToken: jwtToken);
      final String apiUrl =
          '${ApiUrlConstants.GetUserDetails}?mobileUserKey=$mobileKey';
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic getUserData = json.decode(response.body);

        print('GetUserData: $getUserData');

        if (getUserData == null) {
          print('API response is null');
          return null;
        }
        if (getUserData.containsKey('data')) {
          if (getUserData['data'] is Map) {
            Map<String, dynamic> userDataMap = getUserData['data'];
            UserDetailsResponse userDetailsResponse =
                UserDetailsResponse.fromJson(userDataMap);
            return [userDetailsResponse];
          } else if (getUserData['data'] is List) {
            List<dynamic> getUsersData = getUserData['data'];
            List<UserDetailsResponse> list = getUsersData
                .map((userInfo) => UserDetailsResponse.fromJson(userInfo))
                .toList();
            return list;
          }
        } else {
          print('API response does not contain a data field');
          return null;
        }
      } else {
        print(
            'Failed to fetch GetUsersData. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }

    return null;
  }

  Future<void> _loadData() async {
    String fullName = await _sharedPref.read("KingUserProfileName") ?? '';
    String email = await _sharedPref.read("KingUserProfileEmail") ?? '';
    setState(() {
      _userName = fullName.replaceAll('"', '');
      _userEmail = email.replaceAll('"', '');
    });
  }

  Future<void> _refreshUserData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshHelper.buildRefreshIndicator(
      onRefresh: _refreshUserData,
      child: Padding(
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
                      FutureBuilder<List<UserDetailsResponse>?>(
                        future: GetUserDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            List<UserDetailsResponse>? userDetails =
                                snapshot.data;
                            String? ImageUrl = userDetails![0].profileImage;

                            return CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  (ImageUrl != null && ImageUrl.isNotEmpty)
                                      ? NetworkImage(ImageUrl)
                                      : NetworkImage(
                                          'https://static.vecteezy.com/system/resources/previews/002/318/271/original/user-profile-icon-free-vector.jpg',
                                        ),
                              backgroundColor: AppColors.lightShadow,
                            );
                          } else {
                            return CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'images/person_logo.png',
                              ),
                              backgroundColor: AppColors.light,
                            );
                          }
                        },
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
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => PersonalDetails(),
                ))
                    .then((data) {
                  if (data != null) {
                    setState(() {
                      _userName = data['name'];
                      _userEmail = data['email'];
                    });
                  }
                });

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PersonalDetails(),
                //   ),
                // );
              },
              child: Container(
                padding: EdgeInsets.all(12),
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
                padding: EdgeInsets.all(12),
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
                    builder: (context) => MyBucketScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightShadow,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.grey,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'My Bucket',
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
                padding: EdgeInsets.all(12),
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
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Dialog(
                          backgroundColor: AppColors.lightShadow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Confirm Logging Out?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: AppColors.dark),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Are you sure you want to logout.?',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                      ),
                                      onPressed: () {
                                        AccountService().logOut(context);
                                      },
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: AppColors.lightShadow,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: AppColors.light,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                // AccountService().logOut(context),
              },
              // _sharedPref.remove("KingUserToken");
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => GetMobileOtp()),
              //     (route) => false);

              child: Container(
                padding: EdgeInsets.all(12),
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
                  padding: const EdgeInsets.all(12.0),
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
                            SlidingSwitch(
                              value: false,
                              onChanged: (bool value) {
                                setState(() {
                                  isSwtitched = value;
                                });
                              },
                              onTap: () {},
                              onDoubleTap: () {},
                              onSwipe: () {},
                              height: 25,
                              width: 50,
                              animationDuration: Duration(milliseconds: 200),
                              textOn: '',
                              textOff: '',
                              buttonColor: isSwtitched
                                  ? AppColors.primaryColor
                                  : AppColors.cyan,
                            )
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
      ),
    );
  }
}
