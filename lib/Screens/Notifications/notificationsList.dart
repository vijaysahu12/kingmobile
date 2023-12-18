import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/getNotificationsResponse.dart';
import '../Constants/app_color.dart';

class AllNotifications extends StatefulWidget {
  const AllNotifications({super.key});
  @override
  State<AllNotifications> createState() => _AllNotifications();
}

class _AllNotifications extends State<AllNotifications> {
  SharedPref _sharedPref = SharedPref();
  bool isCommunitySelected = true;
  int selectedCategoryId = 0;
  bool isRead = true;

  void _showNotificationPopup(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 400,
              child: Column(
                children: [
                  Row(
                    children: [Text("Course")],
                  ),
                  Row(
                    children: [Text("Live_Seminar")],
                  ),
                  Row(
                    children: [Text("Course")],
                  ),
                  Row(
                    children: [Text("Strategy")],
                  ),
                  Row(
                    children: [Text("Live_Events")],
                  ),
                  Row(
                    children: [Text("Community")],
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<List<NotificationsList>?> NotificationList(selectedCategoryId) async {
    String UserKey = await _sharedPref.read(SessionConstants.UserKey);
    String MobileKey = UserKey.replaceAll('"', '');
    final String apiUrl = '${ApiUrlConstants.GetNotifications}';
    final Map<String, dynamic> requestBody = {
      "id": selectedCategoryId,
      "pageSize": 30,
      "pageNumber": 1,
      "requestedBy": "E551010E-9795-EE11-812A-00155D23D79C"
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

  Future<List<Category>?> fetchCategories() async {
    try {
      final String apiUrl = '${ApiUrlConstants.GetNotifications}';
      final Map<String, dynamic> requestBody = {
        "id": 0,
        "pageSize": 30,
        "pageNumber": 1,
        "requestedBy": "E551010E-9795-EE11-812A-00155D23D79C"
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data.containsKey('data') &&
            data['data'] != null &&
            data['data']['categoriesJson'] is String) {
          List<Category> categories =
              _parseCategories(data['data']['categoriesJson']);
          categories.insert(0, Category(id: 0, name: 'All'));
          return categories;
        }
        throw Exception('Invalid data format for categories');
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return null;
    }
  }

  List<Category> _parseCategories(String categoriesJson) {
    List<dynamic> parsedList = json.decode(categoriesJson);
    List<Category> categories =
        parsedList.map((val) => Category.fromJson(val)).toList();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.purple,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.light,
            ),
          ),
          title: Row(
            children: [
              Text(
                "Notifications",
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.light,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _showNotificationPopup(context);
                  },
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.light,
                  ))
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<List<Category>?>(
                  future: fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading categories'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List<Category> data = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: data.map((category) {
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategoryId = category.id;
                                  });
                                  NotificationList(selectedCategoryId);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCommunitySelected
                                      ? AppColors.lightShadow
                                      : Colors.grey,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                ),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isCommunitySelected
                                        ? AppColors.primaryColor
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return Center(child: Text('No categories available'));
                    }
                  },
                ),
                Expanded(
                  child: FutureBuilder<List<NotificationsList>?>(
                    future: NotificationList(selectedCategoryId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data != null) {
                        List<NotificationsList>? data = snapshot.data!;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  //  color: isRead ? null : AppColors.light,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.cyan, width: 0.4))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data[index].title,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.dark,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  data[index].body,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                data[index].category,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.purple,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
