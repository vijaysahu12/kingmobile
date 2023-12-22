import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/getNotificationsResponse.dart';
import '../Constants/app_color.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<NotificationsList> items = [];
  List<NotificationsList> tempNotifications = [];
  int page = 1;
  int selectedCategoryId = 0;
  int pageSize = 10;
  bool isLoadingMore = false;
  bool hasMoreNotifications = true;
  // bool isRead = false;
  final scrollController = ScrollController();
  SharedPref _sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    unReadCountNotificationList();
    scrollController.addListener(_scrollListener);
    fetchNotifications();
  }

  void _scrollListener() {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      loadPreviousItems();
    } else if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      fetchNotifications();
    }
  }

  Future<List<NotificationsList>?> notificationList(
      selectedCategoryId, int page) async {
    String userKey = _sharedPref.read("KingUserId");
    String mobileKey = userKey.replaceAll('"', '');
    final String apiUrl = '${ApiUrlConstants.GetNotifications}';
    final Map<String, dynamic> requestBody = {
      "id": selectedCategoryId,
      "pageSize": pageSize,
      "pageNumber": page,
      "requestedBy": mobileKey
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final dynamic dataList = json.decode(response.body);
      if (dataList.containsKey('data') &&
          dataList['data'] != null &&
          dataList['data']['notification'] is List) {
        List<dynamic> parsedList = dataList['data']['notification'];
        items = parsedList
            .map((json) => NotificationsList.fromJson(json))
            .cast<NotificationsList>()
            .toList();
      }
      print(items);
      return items;
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load notifications');
    }
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

  Future<int?> unReadCountNotificationList() async {
    String userKey = _sharedPref.read("KingUserId");
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

  Future<void> fetchNotifications() async {
    try {
      final notifications = await notificationList(selectedCategoryId, page);
      if (notifications != null) {
        setState(() {
          if (page == 1) {
            items = List.from(notifications);
          } else {
            tempNotifications = List.from(notifications);
            items.addAll(tempNotifications);
          }
          isLoadingMore = false;
          page++;
          hasMoreNotifications = notifications.isNotEmpty;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> loadPreviousItems() async {
    if (page > 1) {
      try {
        final notifications =
            await notificationList(selectedCategoryId, page - 1);
        if (notifications != null) {
          setState(() {
            isLoadingMore = true;
            items.insertAll(0, notifications);
            page--;
            isLoadingMore = false;
          });
        }
      } catch (e) {
        print('Error loading previous items: $e');
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  List<Category> _parseCategories(String categoriesJson) {
    List<dynamic> parsedList = json.decode(categoriesJson);
    List<Category> categories =
        parsedList.map((val) => Category.fromJson(val)).toList();
    return categories;
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
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            FutureBuilder<List<Category>?>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading categories'));
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
                              });
                              fetchNotifications();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? AppColors.light
                                  : AppColors.lightShadow,
                              side: BorderSide(
                                  color: isActive
                                      ? AppColors.grey
                                      : Colors.transparent,
                                  width: 0.5),
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
              child: ListView.builder(
                controller: scrollController,
                itemCount: isLoadingMore ? items.length + 1 : items.length,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    final id = items[index].id;
                    final title = items[index].title;
                    final body = items[index].body;
                    final category = items[index].category;
                    final isRead = items[index].isRead;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          markNotificationAsRead(id);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isRead
                                ? AppColors.light
                                : AppColors.lightShadow,
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.cyan, width: 0.4))),
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
                                          title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.dark,
                                              fontWeight: FontWeight.w600),
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
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Text(
                                          category,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(id.toString())
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
                    if (index == items.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
