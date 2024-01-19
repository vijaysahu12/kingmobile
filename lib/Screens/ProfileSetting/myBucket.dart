import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kraapp/Helpers/ApiUrls.dart';

import '../../Helpers/sharedPref.dart';
import '../../Models/Response/ProductResponseModel.dart';
import '../../Models/Response/SingleProductResponse.dart';
import '../../Models/Response/myBucketListResponse.dart';
import '../Common/useSharedPref.dart';
import '../Constants/app_color.dart';
import '../Product/readMoreScreen.dart';

class MyBucketScreen extends StatefulWidget {
  const MyBucketScreen({super.key});
  @override
  State<MyBucketScreen> createState() => _MyBucketScreen();
}

class _MyBucketScreen extends State<MyBucketScreen> {
  SharedPref _sharedPref = SharedPref();
  late Future<List<myBucketListResponse>?> myBucketList = myBucketdata();
  UsingSharedPref usingSharedPref = UsingSharedPref();
  UsingHeaders usingHeaders = UsingHeaders();
  late List<bool> isFavoriteList = [];

  @override
  void initState() {
    super.initState();
    myBucketList = myBucketdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateParent() {
    setState(() {
      fetchDataThree();
    });
  }

  Future<SingleProductResponse?> fetchProductById(int productId) async {
    String UserKey = await _sharedPref.read("KingUserId");
    String MobileKey = UserKey.replaceAll('"', '');
    final jwtToken = await usingSharedPref.getJwtToken();
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);
    print(MobileKey);
    final String apiUrl =
        '${ApiUrlConstants.getProductById}?id=$productId&mobileUserKey=$MobileKey';
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      final dynamic parsedData = json.decode(response.body);
      print(response.body);
      return SingleProductResponse.fromJson(parsedData);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<ProductResponseModel>?> fetchDataThree() async {
    String UserKey = await _sharedPref.read(SessionConstants.UserKey);
    String MobileKey = UserKey.replaceAll('"', '');
    final jwtToken = await usingSharedPref.getJwtToken();
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);
    final String apiUrl = '${ApiUrlConstants.getProducts}${MobileKey}';
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      List<ProductResponseModel>? list;
      final dynamic parsedData = json.decode(response.body);
      if (parsedData['data'] is List) {
        List<dynamic> parsedList = parsedData['data'];
        list = parsedList
            .map((val) => ProductResponseModel.fromJson(val))
            .toList();
        isFavoriteList = List.generate(list.length, (index) => false);
        // likeCountList = List.generate(list.length, (index) => 0);
        print(list);
      }
      return list;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<myBucketListResponse>?> myBucketdata() async {
    try {
      final String userKey = await _sharedPref.read(SessionConstants.UserKey);
      final mobileUserKey = userKey.replaceAll('"', '');
      final jwtToken = await usingSharedPref.getJwtToken();
      Map<String, String> headers =
          usingHeaders.createHeaders(jwtToken: jwtToken);
      final String apiUrl =
          '${ApiUrlConstants.MyBucketContent}?userKey=$mobileUserKey';
      // print(jwtToken);
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
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
    } catch (e) {
      throw Exception('Failed to perform request :$e');
    }
  }

  Future<void> Isliked(String productId, bool isHeart) async {
    String userKey = await _sharedPref.read("KingUserId");
    String mobileKey = userKey.replaceAll('"', '');
    final jwtToken = await usingSharedPref.getJwtToken();
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);

    print(mobileKey);
    final String apiUrl = '${ApiUrlConstants.LikeUnlikeProduct}';
    String action = isHeart ? 'like' : 'unlike';
    Map<String, dynamic> isLikedData = {
      'productId': productId,
      "likeId": "1",
      "createdby": mobileKey,
      "action": action,
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(isLikedData),
    );
    print(isLikedData);
    if (response.statusCode == 200) {
      print("Liked successfully!");
    } else {
      print('Failed to update data: ${response.statusCode}');
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
          future: myBucketList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text("No data available");
            } else {
              List<myBucketListResponse>? data = snapshot.data!;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final bool isShowReminder = data[index].showReminder;
                    final int productId = data[index].id;

                    DateTime startdate = data[index].startdate;
                    DateTime enddate = data[index].enddate;

                    String formattedStartDate =
                        DateFormat('dd-MMM-yyyy').format(startdate);
                    String formattedEndDate =
                        DateFormat('dd-MMM-yyyy').format(enddate);
                    return Container(
                      padding: EdgeInsets.all(5),
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
                                          data[index].isHeart =
                                              !data[index].isHeart;
                                        });
                                        await Isliked(data[index].id.toString(),
                                            data[index].isHeart);
                                      },
                                      child: Icon(
                                        data[index].isHeart
                                            ? Icons.favorite
                                            : Icons.favorite_border_rounded,
                                        color: data[index].isHeart
                                            ? Colors.red
                                            : null,
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
                                    Text(formattedStartDate),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(formattedEndDate),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${data[index].daysToGo.toString()} Days to Go End"),
                                    Spacer(),
                                    if (isShowReminder == true)
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
                                        onPressed: () async {
                                          // String productId = data[index].id as String;
                                          SingleProductResponse? product =
                                              await fetchProductById(productId);
                                          print(productId);
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailsScreen(
                                                  product: product,
                                                  updateParent: updateParent,
                                                ),
                                              ),
                                            );
                                          });
                                          fetchProductById(productId);
                                        },
                                        child: Text(
                                          "open",
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
