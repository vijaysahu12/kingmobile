import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Notifications/notificationsList.dart';

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/getNotificationsResponse.dart';
import '../Constants/app_color.dart';

class AppBarBuilder {
  static SharedPref _sharedPref = SharedPref();

  static Future<List<NotificationsList>?> NotificationList() async {
    final String apiUrl = '${ApiUrlConstants.GetNotifications}';
    final Map<String, dynamic> requestBody = {
      "id": 0,
      "pageSize": 3,
      "pageNumber": 3,
      "requestedBy": "9A8AD607-089B-EE11-812B-00155D23D79C"
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      List<NotificationsList>? list;
      final dynamic dataList = json.decode(response.body);
      if (dataList.containsKey('data') &&
          dataList['data'] != null &&
          dataList['data']['notification'] is List) {
        List<dynamic> parsedList = dataList['data']['notification'];
        list =
            parsedList.map((val) => NotificationsList.fromJson(val)).toList();
        print(list);
      }
      return list;
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load notifications');
    }
  }

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
                    IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllNotifications()),
                        );
                      },
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: AppColors.lightShadow,
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              child: Text(
                                "9",
                                style: TextStyle(
                                    color: AppColors.lightShadow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            automaticallyImplyLeading: false,
          );
  }
}
