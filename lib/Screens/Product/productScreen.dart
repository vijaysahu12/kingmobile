import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:kraapp/Screens/Product/readMoreScreen.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/ProductResponseModel.dart';
import '../../Models/Response/SingleProductResponse.dart';
import '../Common/refreshtwo.dart';
import '../Common/shimmerScreen.dart';
import '../Common/useSharedPref.dart';
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
  // late List<int> likeCountList = [];
  late Future<List<ProductResponseModel>?> productsFuture = fetchDataThree();
  SharedPref _sharedPref = SharedPref();
  UsingSharedPref usingSharedPref = UsingSharedPref();
  UsingHeaders usingHeaders = UsingHeaders();

  @override
  void initState() {
    super.initState();
    productsFuture = fetchDataThree();
    _pageController = PageController(initialPage: 0);
  }

  void updateParent() {
    setState(() {
      productsFuture = fetchDataThree();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    await fetchDataThree();
  }

  //success
  // void paymentSuccessResponse(PaymentSuccessResponse response) {
  //   showAlertDialog(
  //       context, "Payment Successful", "Payment ID: ${response.paymentId}");
  // }
  // void paymentFailureResponse(PaymentFailureResponse response) {
  //   showAlertDialog(context, "Payment Failed",
  //       "code : ${response.code}\n Description :${response.message}");
  // }
  // void handleExternalWalletSelected(ExternalWalletResponse response) {
  //   showAlertDialog(
  //       context, "External Wallet Selected", "${response.walletName}");
  // }
  // void showAlertDialog(BuildContext context, String title, String message) {
  //   Widget continueButton = ElevatedButton(
  //     child: const Text("Continue"),
  //     onPressed: () {},
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //     actions: [
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response = await http.get(Uri.parse(ApiUrlConstants.getProducts));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     isFavoriteList = List.generate(data.length, (index) => false);
  //     return List<Map<String, dynamic>>.from(data);
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
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

  Future<SingleProductResponse?> fetchProductById(String productId) async {
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

  Future<void> Isliked(String productId, bool userHasHeart) async {
    String UserKey = await _sharedPref.read("KingUserId");
    String MobileKey = UserKey.replaceAll('"', '');
    final jwtToken = await usingSharedPref.getJwtToken();
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);
    final String apiUrl = '${ApiUrlConstants.LikeUnlikeProduct}';
    String action = userHasHeart ? 'like' : 'unlike';

    Map<String, dynamic> isLikedData = {
      'productId': productId,
      "likeId": "1",
      "createdby": MobileKey,
      "action": action
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

  // Future<List<ProductResponseModel>?> fetchDataThree() async {
  //   final response = await http.post(
  //     Uri.parse(ApiUrlConstants.getProducts),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{}),
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> parsedResponse = json.decode(response.body);
  //     if (parsedResponse.containsKey('data') &&
  //         parsedResponse['data'] is List) {
  //       List<ProductResponseModel>? list = (parsedResponse['data'] as List)
  //           .map((val) => ProductResponseModel.fromJson(val))
  //           .toList();
  //       isFavoriteList = List.generate(list.length, (index) => false);
  //       print(list);
  //       return list;
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page == 1) {
          _pageController.animateTo(0,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
          return false;
        }
        return true;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
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
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError) {
                          return ShimmerListView(itemCount: 5);
                        } else {
                          List<ProductResponseModel> data = snapshot.data!;
                          return RefreshHelper.buildRefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                productsFuture = fetchDataThree();
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
                                        fit: BoxFit
                                            .cover, // Adjust this as needed
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
                    FutureBuilder<List<ProductResponseModel>?>(
                      future: productsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError) {
                          return ShimmerListViewForListofItems(itemCount: 7);
                        } else {
                          List<ProductResponseModel> data = snapshot.data!;

                          return Container(
                            height: constraints.maxHeight,
                            child: RefreshHelper.buildRefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  productsFuture = fetchDataThree();
                                });
                              },
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  String formattedRating =
                                      data[index].overAllRating.toString();
                                  if (formattedRating.contains('.') &&
                                      formattedRating.split('.')[1].length >
                                          1) {
                                    formattedRating = formattedRating.substring(
                                        0, formattedRating.indexOf('.') + 2);
                                  }

                                  return Builder(
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () async {
                                          String productId = data[index].id;
                                          SingleProductResponse? product =
                                              await fetchProductById(productId);
                                          print(product);
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
                                        },
                                        child: Card(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          color: AppColors.lightShadow,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side: BorderSide(
                                                color: AppColors.grey,
                                                width: 0.2),
                                          ),
                                          elevation: 5,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: AppColors.grey,
                                                        width: 0.2),
                                                  ),
                                                  child: Image.asset(
                                                    // data[index].image != null &&
                                                    //         data[index].image.isNotEmpty
                                                    //     ? data[index]['image']
                                                    //     :
                                                    //
                                                    'images/cr_1.jpg',
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    data[index]
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          14,
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
                                                              String productId =
                                                                  data[index]
                                                                      .id;
                                                              setState(() {
                                                                if (data[index]
                                                                    .userHasHeart) {
                                                                  data[index]
                                                                      .heartsCount--;
                                                                  data[index]
                                                                          .userHasHeart =
                                                                      false;
                                                                } else {
                                                                  data[index]
                                                                      .heartsCount++;
                                                                  data[index]
                                                                          .userHasHeart =
                                                                      true;
                                                                }
                                                                Isliked(
                                                                    productId,
                                                                    data[index]
                                                                        .userHasHeart);
                                                              });
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  data[index].userHasHeart
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border,
                                                                  color: data[index]
                                                                          .userHasHeart
                                                                      ? Colors
                                                                          .red
                                                                      : null,
                                                                ),
                                                                Text(
                                                                    '${data[index].heartsCount.toStringAsFixed(0)}'),
                                                              ],
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
                                                              data[index]
                                                                  .description,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .grey,
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
                                                                    .parse(data[
                                                                            index]
                                                                        .overAllRating
                                                                        .toString()),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                ignoreGestures:
                                                                    true,
                                                                allowHalfRating:
                                                                    true,
                                                                itemSize: 18,
                                                                onRatingUpdate:
                                                                    (double
                                                                        value) {},
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            formattedRating,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
                                                          ),
                                                          Spacer(),
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              String productId =
                                                                  data[index]
                                                                      .id;
                                                              SingleProductResponse?
                                                                  product =
                                                                  await fetchProductById(
                                                                      productId);

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProductDetailsScreen(
                                                                      product:
                                                                          product,
                                                                      updateParent:
                                                                          updateParent,
                                                                    ),
                                                                  ));
                                                            },
                                                            child: Text(
                                                              'Read More...',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
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
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
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
      ),
    );
  }
}
