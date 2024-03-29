import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kraapp/Helpers/ApiUrls.dart';
import 'package:kraapp/Models/Response/HomeResponse.dart';
import 'package:kraapp/Screens/Common/shimmerScreen.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:http/http.dart' as http;

import '../../Helpers/sharedPref.dart';
import '../Common/refreshtwo.dart';
import '../Common/usingJwt_Headers.dart';
import '../Constants/app_color.dart';

SharedPref _sharedPref = SharedPref();
UsingHeaders usingHeaders = UsingHeaders();

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _Personal();
}

class _Personal extends State<Personal> {
  String selectedButton = 'NSE';
  String selectedMarketButton = 'Gainers';
  late Future<List<HomeResponse>?> dataFuture;
  late Future<List<String>?> dataFutureGainers;
  late Future<List<String>?> dataFutureLosers;
  late Future<List<String>?> dataFuture52WHigh;
  late Future<List<String>?> dataFuture52WLow;

  @override
  void initState() {
    print("Home Screen");
    initializePusherBeams();
    super.initState();
    print(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializePusherBeams() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await PusherBeams.instance.start(ApiUrlConstants.pusherBeamAuthCode);

    final List<String> latestSubscriptionList = await fetchSubscriptionTopics();

    final List<String?> pusherCurrentSubscriptionList =
        await PusherBeams.instance.getDeviceInterests();

    //ToDo: RaviKumar : how to get subscription list of Firebase.
    // final List<String?> fireBaseCurrentSubscriptionList =
    //     await _firebaseMessaging.

    for (final topic in latestSubscriptionList) {
      // await PusherBeams.instance.addDeviceInterest(topic);
      await PusherBeams.instance.addDeviceInterest(topic);
      await _firebaseMessaging.subscribeToTopic(topic);
    }

    for (final item in pusherCurrentSubscriptionList) {
      if (!latestSubscriptionList.contains(item)) {
        await PusherBeams.instance.removeDeviceInterest(item.toString());
        await _firebaseMessaging.unsubscribeFromTopic(item.toString());
      }
    }
    print(pusherCurrentSubscriptionList);
  }

  Future<List<String>> fetchSubscriptionTopics() async {
    UsingJwtToken usingJwtToken = UsingJwtToken();

    try {
      final String? userKey = await _sharedPref.read(SessionConstants.UserKey);
      if (userKey != null) {
        final mobileUserKey = userKey.replaceAll('"', '');
        final jwtToken = await usingJwtToken.getJwtToken();

        // ignore: unnecessary_null_comparison
        if (jwtToken != null) {
          Map<String, String> headers =
              usingHeaders.createHeaders(jwtToken: jwtToken);
          final apiUrl =
              '${ApiUrlConstants.GetSubscriptionTopics}?userKey=$mobileUserKey';
          final response = await http.get(Uri.parse(apiUrl), headers: headers);

          if (response.statusCode == 200) {
            final getSubscriptionData = jsonDecode(response.body);
            final List<dynamic> topicList =
                json.decode(getSubscriptionData['data']);
            return topicList.map((topic) => topic['code'].toString()).toList();
          } else {
            throw Exception("Failed to fetch Subscription topics");
          }
        } else {
          throw Exception("JWT Token is null");
        }
      } else {
        throw Exception("User key is null");
      }
    } catch (e) {
      print('Error fetching subscription topics: $e');
      return []; // Return an empty list or handle the error accordingly
    }
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  int _currentIndex = 0;
  Key carouselKey = UniqueKey();

  final List<String> imagePaths = [
    'images/cr_1.jpg',
    'images/cr_2.jpg',
    'images/cr_3.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return RefreshHelper.buildRefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Column(
                children: [
                  CarouselSlider(
                    key: carouselKey,
                    items: imagePaths.map((imagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true,
                      initialPage: _currentIndex,
                      enableInfiniteScroll: true,
                      reverse: true,
                      autoPlayInterval: Duration(seconds: 800),
                      autoPlayAnimationDuration: Duration(microseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imagePaths.asMap().entries.map((entry) {
                      final int index = entry.key;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            carouselKey = UniqueKey();
                          });
                        },
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 6.0), // Adjust spacing
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? AppColors.primaryColor
                                : AppColors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.grey, width: 0.3),
                color: AppColors.lightShadow,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark
                        .withOpacity(0.2), // Color and opacity of the shadow
                    spreadRadius: 2, // Spread radius of the shadow
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = 'NSE';
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: selectedButton == 'NSE'
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppColors.dark))
                                  : null),
                          child: Text(
                            'NSE',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'poppins',
                                color: selectedButton == 'NSE'
                                    ? AppColors.primaryColor
                                    : AppColors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = 'BSE';
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: selectedButton == 'BSE'
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppColors.dark))
                                  : null),
                          child: Text(
                            'BSE',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'poppins',
                                color: selectedButton == 'BSE'
                                    ? AppColors.primaryColor
                                    : AppColors.grey),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Market Watch',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'poppins',
                              color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 8,
                      bottom: 5,
                    ),
                    child: Column(
                      children: [
                        if (selectedButton == 'NSE')
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColors.grey, width: 0.5),
                                    color: AppColors.light),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nifty 50',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '19.674.55 (0.00%)',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColors.grey, width: 0.5),
                                  color: AppColors.light,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nifty Bank',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '44,766.10 (0.35%)',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        else if (selectedButton == 'BSE')
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColors.grey, width: 0.5),
                                    color: AppColors.light),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nifty 50',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '19.674. (0.%)',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColors.grey, width: 0.5),
                                  color: AppColors.light,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nifty ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '44,.10 (0.35%)',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 10,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // FutureBuilder<List<String>?>(
            //   future: _sharedPref.readList("topGainersList"),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return ShimmerListViewForHome(itemCount: 1);
            //     } else if (snapshot.hasData && snapshot.data != null) {
            //       List<String> topGainersList = snapshot.data!;
            //       return

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'In Markets',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'poppins'),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.grey, width: 0.3),
                          color: AppColors.lightShadow,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: selectedMarketButton == 'Gainers'
                                          ? Border(
                                              bottom: BorderSide(
                                                  color: AppColors.dark,
                                                  width: 1))
                                          : null),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedMarketButton = 'Gainers';
                                      });
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all(Size(0, 0)),
                                    ),
                                    child: Text(
                                      'Gainers',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'poppins',
                                        color: selectedMarketButton == 'Gainers'
                                            ? AppColors.primaryColor
                                            : AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      border: selectedMarketButton == 'Losers'
                                          ? Border(
                                              bottom: BorderSide(
                                                  color: AppColors.dark,
                                                  width: 1))
                                          : null),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedMarketButton = 'Losers';
                                      });
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all(Size(0, 0)),
                                    ),
                                    child: Text(
                                      'Losers',
                                      style: TextStyle(
                                        color: selectedMarketButton == 'Losers'
                                            ? AppColors.primaryColor
                                            : AppColors.grey,
                                        fontSize: 10,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      border: selectedMarketButton == '52W High'
                                          ? Border(
                                              bottom: BorderSide(
                                                  color: AppColors.dark,
                                                  width: 1),
                                            )
                                          : null),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedMarketButton = '52W High';
                                      });
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all(Size(0, 0)),
                                    ),
                                    child: Text(
                                      '52W High',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'poppins',
                                        color:
                                            selectedMarketButton == '52W High'
                                                ? AppColors.primaryColor
                                                : AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      border: selectedMarketButton == '52W Low'
                                          ? Border(
                                              bottom: BorderSide(
                                                  color: AppColors.dark,
                                                  width: 1))
                                          : null),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedMarketButton = '52W Low';
                                      });
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all(Size(0, 0)),
                                    ),
                                    child: Text(
                                      '52W Low',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'poppins',
                                        color: selectedMarketButton == '52W Low'
                                            ? AppColors.primaryColor
                                            : AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Column(
                              children: [
                                if (selectedMarketButton == 'Gainers')
                                  FutureBuilder<List<String>?>(
                                    future:
                                        _sharedPref.readList('topGainersList'),
                                    builder: (context, snapshot) {
                                      return buildDataListView(snapshot);
                                    },
                                  )
                                else if (selectedMarketButton == 'Losers')
                                  FutureBuilder<List<String>?>(
                                    future:
                                        _sharedPref.readList('topLosersList'),
                                    builder: (context, snapshot) {
                                      return buildDataListView(snapshot);
                                    },
                                  )
                                else if (selectedMarketButton == '52W High')
                                  FutureBuilder<List<String>?>(
                                    future:
                                        _sharedPref.readList('topLosersList'),
                                    builder: (context, snapshot) {
                                      return buildDataListView(snapshot);
                                    },
                                  )
                                else if (selectedMarketButton == '52W Low')
                                  FutureBuilder<List<String>?>(
                                    future:
                                        _sharedPref.readList('topLosersList'),
                                    builder: (context, snapshot) {
                                      return buildDataListView(snapshot);
                                    },
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      );
    });
  }
}

Widget buildDataListView(AsyncSnapshot<List<String>?> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting ||
      snapshot.hasError) {
    return ShimmerListViewForHome(itemCount: 1);
  } else if (snapshot.hasData && snapshot.data != null) {
    List<String> data = snapshot.data!;
    return Column(
      children: data.map((product) {
        List<String> parts = product.split(', cp:');
        if (parts.length == 2) {
          String stockName = parts[0].trim();
          String cpValue = parts[1].trim();

          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey, width: 0.3),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Text(
                        stockName,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 10,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '$cpValue',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey, width: 0.3),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Text(
                        "stockName",
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 10,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'cpValue',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.grey, width: 0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 5),
                Text(
                  'Empty List',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 10,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
