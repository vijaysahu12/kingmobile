import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Helpers/ApiUrls.dart';
import '../../Models/Response/CommunityGroupResponse.dart';

import '../Common/refreshtwo.dart';
import '../Constants/app_color.dart';

class CommunityGroup extends StatefulWidget {
  const CommunityGroup({Key? key}) : super(key: key);

  @override
  State<CommunityGroup> createState() => _CommunityGroupState();
}

class _CommunityGroupState extends State<CommunityGroup> {
  late PageController _pageController;
  bool isCommunitySelected = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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
      // ignore: unnecessary_null_comparison
      if (response != null) {
        final List parsedList = json.decode(response.body);
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
        return RefreshHelper.buildRefreshIndicator(
          onRefresh: RefreshHelper.defaultOnRefresh,
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 2, left: 18, right: 18),
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
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [Center(child: Text('Wait a moment...'))],
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<CommunityGroupResponse> data = snapshot.data!;

                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.grey, width: 0.3)),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    // data[index]['image'] != null &&
                                    //         data[index]['image'].isNotEmpty
                                    //     ? data[index]['image']
                                    //     :
                                    'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<CommunityGroupResponse>?>(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [Center(child: Text('Wait a moment...'))],
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<CommunityGroupResponse> data = snapshot.data!;
                          return ListView.builder(
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
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          // data[index]['image'] != null &&
                                          //         data[index]['image']
                                          //             .isNotEmpty
                                          //     ? data[index]['image']
                                          //     :
                                          'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
                                          height: 100,
                                          width: 100,
                                        ),
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
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
