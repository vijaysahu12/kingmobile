import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Common/useSharedPref.dart';
import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/UserDetailsResponse.dart';
import '../Constants/app_color.dart';
import '../Notifications/allNotificationList.dart';
// import '../Notifications/notificationsList.dart';
// import '../Notifications/notificationsListTwo.dart';

SharedPref _sharedPref = SharedPref();
UsingHeaders usingHeaders = UsingHeaders();

Future<int?> NotificationList() async {
  final String userKey = await _sharedPref.read(SessionConstants.UserKey);
  String mobileKey = userKey.replaceAll('"', '');
  UsingSharedPref usingSharedPref = UsingSharedPref();
  final jwtToken = await usingSharedPref.getJwtToken();
  Map<String, String> headers = usingHeaders.createHeaders(jwtToken: jwtToken);
  final String apiUrl = '${ApiUrlConstants.GetNotifications}';
  final Map<String, dynamic> requestBody = {
    "id": 0,
    "pageSize": 10,
    "pageNumber": 1,
    "requestedBy": mobileKey
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final dynamic jsonResponse = await jsonDecode(response.body);

    if (jsonResponse.containsKey('data') &&
        jsonResponse['data'] != null &&
        jsonResponse['data']['unReadCount'] != null) {
      final int parsedCount = jsonResponse['data']['unReadCount'] as int;
      print(parsedCount);
      return parsedCount;
    }
    return 0;
  } else {
    print('Request failed with status: ${response.statusCode}');
    throw Exception('Failed to load notifications');
  }
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

@override
void initState() {
  initState();
}

@override
void dispose() {
  dispose();
}

class AppBarBuilder {
  static SharedPref _sharedPref = SharedPref();

  static Future<String> loadUserName() async {
    String fullName = await _sharedPref.read("KingUserProfileName") ?? '';
    return fullName.replaceAll('"', '');
  }

  static AppBar buildAppBar(BuildContext context, int currentIndex) {
    return currentIndex == 3
        ? AppBar(
            backgroundColor: AppColors.purple,
            automaticallyImplyLeading: false,
          )
        : AppBar(
            backgroundColor: AppColors.purple,
            title: FutureBuilder<String>(
              future: loadUserName(),
              builder: (context, snapshot) {
                String _userName = snapshot.data ?? '';
                return Row(
                  children: [
                    FutureBuilder<List<UserDetailsResponse>?>(
                      future: GetUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          List<UserDetailsResponse>? userDetails =
                              snapshot.data;
                          String imgurl = userDetails![0].profileImage;

                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('$imgurl'),
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
                    SizedBox(width: 10),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightShadow,
                      ),
                    ),
                    Spacer(),
                    FutureBuilder(
                        future: NotificationList(),
                        builder: (context, snapshot) {
                          int? unreadCount = snapshot.data;
                          return IconButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllNotifications()),
                                );
                              },
                              icon: Stack(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.notifications,
                                      color: AppColors.light,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllNotifications()),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      child: Center(
                                        child: Text(
                                          unreadCount.toString(),
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        }),
                  ],
                );
              },
            ),
            automaticallyImplyLeading: false,
          );
  }
}
