import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Helpers/ApiUrls.dart';
import '../../Models/Response/ProductResponseModel.dart';
import '../Constants/app_color.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key}) : super(key: key);

  @override
  State<TradingScreen> createState() => _TradingScreen();
}

class _TradingScreen extends State<TradingScreen> {
  late PageController _pageController;
  bool isCommunitySelected = true;
  late List<bool> isFavoriteList = [];
  late Future<List<ProductResponseModel>?> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchDataThree();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(ApiUrlConstants.getProducts));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      isFavoriteList = List.generate(data.length, (index) => false);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
  // Future<List<ProductResponseModel>?> fetchDataNew() async {
  //   var res = await _productService.getProductDetails();
  //   return res;
  //   //final response = await http.get(Uri.parse(ApiUrlConstants.getProducts));

  //   // if (response.statusCode == 200) {
  //   //   final List<dynamic> data = json.decode(response.body);

  //   //   isFavoriteList = List.generate(data.length, (index) => false);
  //   //   return List<Map<String, dynamic>>.from(data);
  //   // } else {
  //   //   throw Exception('Failed to load data');
  //   // }
  // }

  Future<List<ProductResponseModel>?> fetchDataThree() async {
    final response = await http.get(Uri.parse(ApiUrlConstants.getProducts));
    if (response.statusCode == 200) {
      List<ProductResponseModel>? list = null;
      // ignore: unnecessary_null_comparison
      if (response != null) {
        final List parsedList = json.decode(response.body);
        list = parsedList
            .map((val) => ProductResponseModel.fromJson(val))
            .toList();
        isFavoriteList = List.generate(list.length, (index) => false);
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
                      'Services',
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
                      'Algo Trading',
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
                  FutureBuilder<List<ProductResponseModel>?>(
                    future: productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            Center(
                              child: Text('Please wait...'),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<ProductResponseModel> data = snapshot.data!;

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
                  FutureBuilder<List<ProductResponseModel>?>(
                    future: productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            Center(
                              child: Text('Please wait...'),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<ProductResponseModel> data = snapshot.data!;
                        return Container(
                          height: constraints.maxHeight,
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Builder(
                                builder: (context) {
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    color: AppColors.lightShadow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                          color: AppColors.grey, width: 0.2),
                                    ),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors.grey,
                                                  width: 0.2),
                                            ),
                                            child: Image.network(
                                              // data[index].image != null &&
                                              //         data[index].image.isNotEmpty
                                              //     ? data[index]['image']
                                              //     :
                                              //
                                              'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              data[index].name,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isFavoriteList[
                                                                  index] =
                                                              !isFavoriteList[
                                                                  index];
                                                        });
                                                      },
                                                      child: Icon(
                                                        isFavoriteList[index]
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        color: isFavoriteList[
                                                                index]
                                                            ? Colors.red
                                                            : null,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[index].description,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        RatingBar.builder(
                                                          initialRating: double
                                                              .parse(data[index]
                                                                  .raiting
                                                                  .toString()),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          ignoreGestures: true,
                                                          itemSize: 18,
                                                          onRatingUpdate:
                                                              (double value) {},
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryColor,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  WillPopScope(
                                                                onWillPop:
                                                                    () async {
                                                                  return true;
                                                                },
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Center(
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 200.0),
                                                                      height:
                                                                          300,
                                                                      child:
                                                                          Dialog(
                                                                        backgroundColor:
                                                                            AppColors.lightShadow,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                          decoration:
                                                                              BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Text(
                                                                                      data[index].name,
                                                                                      style: TextStyle(fontSize: 16, fontFamily: 'poppins', fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Flexible(
                                                                                      child: Text(
                                                                                        data[index].description,
                                                                                        style: TextStyle(fontSize: 14, fontFamily: 'poppins', fontWeight: FontWeight.w600, color: AppColors.grey),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    RatingBar.builder(
                                                                                      initialRating: double.parse(data[index].raiting.toString()),
                                                                                      itemBuilder: (context, _) => Icon(
                                                                                        Icons.star,
                                                                                        color: Colors.amber,
                                                                                      ),
                                                                                      ignoreGestures: true,
                                                                                      itemSize: 18,
                                                                                      onRatingUpdate: (double value) {},
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Text(
                                                                                      ' ${data[index].price.toString()} Rs',
                                                                                      style: TextStyle(fontSize: 16, fontFamily: 'poppins', fontWeight: FontWeight.bold, color: AppColors.dark),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                          backgroundColor: AppColors.primaryColor,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            Navigator.pop(context);
                                                                                          });
                                                                                        },
                                                                                        child: Text("Continue"),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text('Buy'),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
