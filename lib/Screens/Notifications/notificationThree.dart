import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:kraapp/Models/Response/getNotificationsResponse.dart';

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/getNotificationsResponse.dart';
import '../Constants/app_color.dart';

class NotificationThree extends StatefulWidget {
  const NotificationThree({super.key});

  @override
  State<NotificationThree> createState() => _NotificationThree();
}

class _NotificationThree extends State<NotificationThree> {
  List Items = [];
  int page = 0;
  int pageSize = 10;
  bool isLoadingMore = false;
  final scrollContoller = ScrollController();
  int selectedCategoryId = 0;
  SharedPref _sharedPref = SharedPref();

  Future<void> fetchData() async {
    String userKey = _sharedPref.read("KingUserId");
    String mobileKey = userKey.replaceAll('"', '');
    String apiURL = "${ApiUrlConstants.GetNotifications}";
    final Map<String, dynamic> requestBody = {
      "id": selectedCategoryId,
      "pageSize": 15,
      "pageNumber": page,
      "requestedBy": mobileKey
    };
    final response = await http.post(
      Uri.parse(apiURL),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final dynamic notificationData = data['data']['notification'];

      if (notificationData != null && notificationData is List<dynamic>) {
        setState(() {
          Items.addAll(notificationData);
          page++;
        });
      } else {
        print('Notification data is invalid or null');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    scrollContoller.addListener(_scrollListener);
    fetchData();
    //  unReadCountNotificationList();
  }

  void _scrollListener() {
    if (isLoadingMore) return;
    if (scrollContoller.position.pixels ==
        scrollContoller.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page++;
      fetchData().then((_) {
        setState(() {
          isLoadingMore = false;
        });
      });
    } else if (scrollContoller.position.pixels ==
        scrollContoller.position.minScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      fetchData().then((_) {
        setState(() {
          isLoadingMore = false;
        });
      });
    }
  }

  Future<List<Category>?> fetchCategories() async {
    String userKey = _sharedPref.read("KingUserId");
    String mobileKey = userKey.replaceAll('"', '');
    try {
      final String apiUrl = '${ApiUrlConstants.GetNotifications}';
      final Map<String, dynamic> requestBody = {
        "id": 0,
        "pageSize": 30,
        "pageNumber": 1,
        "requestedBy": mobileKey
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

  Future<int?> unReadCountNotificationList() async {
    String userKey = await _sharedPref.read("KingUserId");
    String mobileKey = userKey.replaceAll('"', '');
    final String apiUrl = '${ApiUrlConstants.GetNotifications}';
    final Map<String, dynamic> requestBody = {
      "id": 0,
      "pageSize": 200,
      "pageNumber": 1,
      "requestedBy": mobileKey
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final dynamic unReadCount = await jsonDecode(response.body);
      if (unReadCount.containsKey('data') &&
          unReadCount['data'] != null &&
          unReadCount['data']['unReadCount'] != null) {
        final int parsedCount = unReadCount['data']['unReadCount'];
        print(parsedCount);
        return parsedCount;
      }
      return null;
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load notifications');
    }
  }

  List<Category> _parseCategories(String categoriesJson) {
    List<dynamic> parsedList = json.decode(categoriesJson);
    List<Category> categories =
        parsedList.map((val) => Category.fromJson(val)).toList();
    return categories;
  }

  Future<void> markNotificationAsRead(int id) async {
    String apiUrl = '${ApiUrlConstants.MarkNotificationsIsRead}?id=${id}';
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print("Notification is Marked");
    } else {
      print("Failder to mark");
    }
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
                  // _showNotificationPopup(context);
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.light,
                ))
          ],
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Category>?>(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data != null) {
                List<Category> data = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.map((category) {
                      bool isActive = selectedCategoryId == category.id;
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategoryId = category.id;
                              page = 0;
                              Items.clear();
                            });
                            fetchData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive
                                ? AppColors.light
                                : AppColors.lightShadow,
                            side: BorderSide(
                              color: isActive
                                  ? AppColors.grey
                                  : Colors.transparent,
                              width: 0.5,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: isActive ? AppColors.blue : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Expanded(
            child: Container(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ListView.builder(
                    controller: scrollContoller,
                    itemCount: isLoadingMore ? Items.length + 1 : Items.length,
                    itemBuilder: (context, index) {
                      // if (isLoadingMore)
                      if (index < Items.length) {
                        final title = Items[index]['title'];
                        final body = Items[index]['body'];
                        final category = Items[index]['category'];
                        final ids = Items[index]['id'];
                        final isRead = Items[index]['isRead'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              markNotificationAsRead(ids);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isRead
                                  ? AppColors.light
                                  : AppColors.lightShadow,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.cyan,
                                  width: 0.4,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.dark,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                body,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.purple,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ids.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.purple,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
