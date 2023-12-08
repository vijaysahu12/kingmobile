import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Helpers/ApiUrls.dart';
import '../../Models/Response/CommunityGroupResponse.dart';

import '../Common/refreshtwo.dart';
import '../Common/shimmerScreen.dart';
import '../Constants/app_color.dart';

class CommunityGroup extends StatefulWidget {
  const CommunityGroup({Key? key}) : super(key: key);

  @override
  State<CommunityGroup> createState() => _CommunityGroupState();
}

class _CommunityGroupState extends State<CommunityGroup> {
  late PageController _pageController;
  bool isCommunitySelected = true;
  late Future<List<CommunityGroupResponse>?> dataFuture;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    dataFuture = fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<CommunityGroupResponse>?> fetchData() async {
    final response = await http.get(Uri.parse(ApiUrlConstants.getProducts));
    if (response.statusCode == 200) {
      List<CommunityGroupResponse>? list;
      final dynamic parsedData = json.decode(response.body);
      if (parsedData['data'] is List) {
        List<dynamic> parsedList = parsedData['data'];
        list = parsedList
            .map((val) => CommunityGroupResponse.fromJson(val))
            .toList();
        print(list);
      }
      return list;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 2, left: 18, right: 18),
              decoration: BoxDecoration(
                  color: AppColors.lightShadow,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isCommunitySelected = true;
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      });
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor:
                            isCommunitySelected ? AppColors.light : null,
                        padding: EdgeInsets.symmetric(horizontal: 45)),
                    child: Text(
                      'Community',
                      style: TextStyle(
                          color: isCommunitySelected
                              ? AppColors.primaryColor
                              : AppColors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isCommunitySelected = false;
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      });
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor:
                            !isCommunitySelected ? AppColors.light : null,
                        padding: EdgeInsets.symmetric(horizontal: 45)),
                    child: Text(
                      'Groups',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: !isCommunitySelected
                              ? AppColors.primaryColor
                              : AppColors.grey),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    isCommunitySelected = index == 0;
                  });
                },
                children: [
                  FutureBuilder<List<CommunityGroupResponse>?>(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError) {
                        return ShimmerListView(itemCount: 5);
                      } else {
                        List<CommunityGroupResponse> data = snapshot.data!;

                        return RefreshHelper.buildRefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              dataFuture = fetchData();
                            });
                          },
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'images/cr_1.jpg',
                                      height: 130,
                                      width: 300,
                                      fit:
                                          BoxFit.cover, // Adjust this as needed
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<CommunityGroupResponse>?>(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError) {
                        return ShimmerListViewForListofItems(itemCount: 7);
                      } else {
                        List<CommunityGroupResponse> data = snapshot.data!;
                        return RefreshHelper.buildRefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              dataFuture = fetchData();
                            });
                          },
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: AppColors.grey, width: 0.5),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                          // data[index]['image'] != null &&
                                          //         data[index]['image']
                                          //             .isNotEmpty
                                          //     ? data[index]['image']
                                          //     :
                                          'images/cr_1.jpg',
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // data[index]['name'],
                                              data[index].name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              // data[index]['description'],
                                              data[index].description,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            )),
                                        onPressed: () {},
                                        child: Text(
                                          ' Join ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.light),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
