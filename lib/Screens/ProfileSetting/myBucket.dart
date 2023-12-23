import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kraapp/Helpers/ApiUrls.dart';

import '../../Helpers/sharedPref.dart';
import '../../Models/Response/myBucketListResponse.dart';
import '../Constants/app_color.dart';

class MyBucketScreen extends StatefulWidget {
  const MyBucketScreen({super.key});
  @override
  State<MyBucketScreen> createState() => _MyBucketScreen();
}

class _MyBucketScreen extends State<MyBucketScreen> {
  SharedPref _sharedPref = SharedPref();
  bool isLiked = true;
  bool showReminder = false;

  @override
  void initState() {
    super.initState();
    // myBucketdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<myBucketListResponse>?> myBucketdata() async {
    final String userKey = await _sharedPref.read(SessionConstants.UserKey);
    final mobileUserKey = userKey.replaceAll('"', '');
    final String apiUrl =
        '${ApiUrlConstants.MyBucketContent}?userKey=$mobileUserKey';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print("called myBacket api");
      List<myBucketListResponse>? list;
      final dynamic ListOfBucket = json.decode(response.body);
      if (ListOfBucket['data'] is List) {
        List<dynamic> bucketList = ListOfBucket['data'];
        list = bucketList
            .map((listOfItems) => myBucketListResponse.fromJson(listOfItems))
            .toList();
      }
      return list;
    } else {
      throw Exception("failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          "MyBucketList",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "poppins",
            fontWeight: FontWeight.w600,
            color: AppColors.lightShadow,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.lightShadow,
            size: 25,
          ),
        ),
      ),
      body: FutureBuilder<List<myBucketListResponse>?>(
          future: myBucketdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
            } else if (snapshot.hasError) {
              return Text(
                  "Error: ${snapshot.error}"); // Show an error message if fetching data fails.
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text(
                  "No data available"); // Handle case where no data is available.
            } else {
              List<myBucketListResponse>? data = snapshot.data!;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final String isShowReminder = "${data[index].showReminder}";
                    return Container(
                      padding: EdgeInsets.all(5),
                      // height: 130,
                      decoration: BoxDecoration(
                          color: AppColors.cyan,
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "images/cr_3.jpg",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${data[index].name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          // if (data[index].isHeart) {
                                          //   data[index].isHeart = false;
                                          // } else {
                                          //   data[index].isHeart = true;
                                          // }
                                        });
                                      },
                                      child: Icon(
                                        data[index].isHeart
                                            ? Icons.favorite
                                            : Icons.favorite_border_rounded,
                                        color: isLiked ? Colors.red : null,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${data[index].categoryName}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Stated Date"),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text("End Date"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${data[index].daysToGo.toString()} Days to Go End"),
                                    Spacer(),
                                    if (isShowReminder != true)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Renew",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.light,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}
