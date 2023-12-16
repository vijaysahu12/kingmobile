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

  bool isRead = true;
  Scaffold showSnackbar(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: []),
    );
  }

  Future<List<NotificationsList>?> NotificationList() async {
    String UserKey = await _sharedPref.read(SessionConstants.UserKey);
    String MobileKey = UserKey.replaceAll('"', '');
    final String apiUrl = '${ApiUrlConstants.GetNotifications}';
    final Map<String, dynamic> requestBody = {
      "id": 0,
      "pageSize": 9,
      "pageNumber": 1,
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
                  onPressed: () {},
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
                Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 2, left: 18, right: 18),
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCommunitySelected = true;
                            });
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  isCommunitySelected ? AppColors.light : null,
                              padding: EdgeInsets.symmetric(horizontal: 45)),
                          child: Text(
                            'All',
                            style: TextStyle(
                                color: isCommunitySelected
                                    ? AppColors.primaryColor
                                    : AppColors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCommunitySelected = false;
                            });
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  !isCommunitySelected ? AppColors.light : null,
                              padding: EdgeInsets.symmetric(horizontal: 45)),
                          child: Text(
                            'Product One',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: !isCommunitySelected
                                    ? AppColors.primaryColor
                                    : AppColors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCommunitySelected = true;
                            });
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  isCommunitySelected ? AppColors.light : null,
                              padding: EdgeInsets.symmetric(horizontal: 45)),
                          child: Text(
                            'All',
                            style: TextStyle(
                                color: isCommunitySelected
                                    ? AppColors.primaryColor
                                    : AppColors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCommunitySelected = false;
                            });
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  !isCommunitySelected ? AppColors.light : null,
                              padding: EdgeInsets.symmetric(horizontal: 45)),
                          child: Text(
                            'Product One',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: !isCommunitySelected
                                    ? AppColors.primaryColor
                                    : AppColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<NotificationsList>?>(
                    future: NotificationList(),
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
                                              Text(
                                                data[index].body,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Spacer(),
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


  // body: FutureBuilder<List<NotificationsList>?>(
      //   future: NotificationList(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasData && snapshot.data != null) {
      //       List<NotificationsList>? data = snapshot.data!;
      //       return ListView.builder(
      //         itemCount: data.length,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             decoration: BoxDecoration(
      //                 //  color: isRead ? null : AppColors.light,
      //                 border: Border(
      //                     bottom:
      //                         BorderSide(color: AppColors.cyan, width: 0.4))),
      //             margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 10, vertical: 12),
      //               child: Row(
      //                 children: [
      //                   Expanded(
      //                     child: Column(
      //                       children: [
      //                         Row(
      //                           children: [
      //                             Text(
      //                               data[index].title,
      //                               style: TextStyle(
      //                                   fontSize: 16,
      //                                   color: AppColors.dark,
      //                                   fontWeight: FontWeight.w600),
      //                             )
      //                           ],
      //                         ),
      //                         Row(
      //                           children: [
      //                             Text(
      //                               data[index].body,
      //                               style: TextStyle(
      //                                   fontSize: 14,
      //                                   color: AppColors.grey,
      //                                   fontWeight: FontWeight.w500),
      //                             ),
      //                             Spacer(),
      //                             Text(
      //                               data[index].category,
      //                               style: TextStyle(
      //                                   fontSize: 12,
      //                                   color: AppColors.purple,
      //                                   fontWeight: FontWeight.w600),
      //                             ),
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
   