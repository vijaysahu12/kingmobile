import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Common/useSharedPref.dart';
import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
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
    "pageSize": 200,
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
                    CircleAvatar(
                      backgroundImage: AssetImage('images/person_logo.png'),
                      radius: 20,
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
