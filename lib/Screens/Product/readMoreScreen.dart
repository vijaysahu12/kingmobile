import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kraapp/Models/Response/SingleProductResponse.dart';
import 'package:kraapp/Screens/Common/refreshtwo.dart';

import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';
import '../Common/shimmerScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final SingleProductResponse? product;
  final Function updateParent;

  const ProductDetailsScreen(
      {this.product, super.key, required this.updateParent});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var isPaid = false;
  SharedPref _sharedPref = SharedPref();
  bool isCommunitySelected = true;
  late PageController _pageController;

  List<String> myVideoUrls = [
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
  ];
  final String videoUrl = 'https://youtu.be/uR8Gc5htyr0?si=6938x8gYU-qSXgUb';

  // void openYoutubeVideo(BuildContext context, String videoUrl) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => YoutubePlayerScreen(videoUrls: myVideoUrls),
  //     ),
  //   );
  // }

  Future<void> Isliked(String productId, bool isHeart) async {
    // String userKey = await _sharedPref.read("KingUserId");
    // String mobileKey = userKey.replaceAll('"', '');
    final String apiUrl = '${ApiUrlConstants.LikeUnlikeProduct}';
    String action = isHeart ? 'like' : 'unlike';
    Map<String, dynamic> isLikedData = {
      'productId': productId,
      "likeId": "1",
      "createdby": "469FA374-A295-EE11-812A-00155D23D79C",
      "action": action,
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(isLikedData),
    );
    print(isLikedData);
    if (response.statusCode == 200) {
      print("Liked successfully!");
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  void paymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void paymentFailureResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "code : ${response.code}\n Description :${response.message}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    String fullName = await _sharedPref.read("KingUserProfileName") ?? '';
    setState(() {
      _userName = fullName.replaceAll('"', '');
    });
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
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.lightShadow,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
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
                      'Overview',
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
                      'Content',
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
                  _buildOverviewContent(),
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.purple,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${widget.product!.data[0].price.toString()}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightShadow),
              ),
              if (isPaid)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      Razorpay razorpay = Razorpay();
                      var options = {
                        'key': 'rzp_test_8x2It6dJUckx0i',
                        'amount':
                            '${(widget.product!.data[0].price * 100).toString()}',
                        'name': '${widget.product!.data[0].name}',
                        'description': '${widget.product!.data[0].description}',
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '6309373318',
                          'email': 'kakuseshadri033@gmail.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        }
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          paymentSuccessResponse);
                      razorpay.on(
                          Razorpay.EVENT_PAYMENT_ERROR, paymentFailureResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightShadow,
                    ),
                  ),
                ),
              if (isPaid != true)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    // openYoutubeVideo(context, videoUrl);
                  },
                  child: Text(
                    "Open",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightShadow,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.product!.data.length,
              itemBuilder: (context, index) {
                final Product currentProduct = widget.product!.data[index];
                ExtraBenefit? benefit;

                if (currentProduct.extraBenefits.isNotEmpty) {
                  benefit = currentProduct.extraBenefits[index];
                  print(benefit);
                } else {
                  print('No extra benefits available');
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              '${currentProduct.name}',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            try {
                              setState(() {
                                currentProduct.isHeart =
                                    !currentProduct.isHeart;
                              });

                              await Isliked(
                                  currentProduct.id, currentProduct.isHeart);
                              widget.updateParent();
                            } catch (error) {
                              print('Error occurred: $error');
                            }
                          },
                          child: Column(
                            children: [
                              Icon(
                                currentProduct.isHeart
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    currentProduct.isHeart ? Colors.red : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              '${currentProduct.category}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(
                                  currentProduct.rating.toString()),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              itemSize: 25,
                              onRatingUpdate: (double value) {},
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/cr_1.jpg',
                              height: 130,
                              width: 300,
                              fit: BoxFit.cover, // Adjust this as needed
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "About This Course",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${currentProduct.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 30,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "6 Months Validity",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "You will get this course for 6 full Month(s)",
                                  style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCommunitySelected = true;
                        });

                        _pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.primaryColor),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 30,
                                  color: AppColors.light,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "6 Learning Material",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "6  Video lectures",
                                    style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 12,
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                                color: AppColors.dark,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: AppColors.grey,
                      thickness: 3.0,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              "images/cloudQuestion.jpg",
                              height: 50,
                              width: 50,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Facing any difficulties,${_userName}?",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Talk to me instantly',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: AppColors.grey,
                      thickness: 3.0,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (benefit != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Extra Benefits",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.dark,
                                fontWeight: FontWeight.w600,
                                fontFamily: "poppins"),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    benefit.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        benefit.subscriptionName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),
                              Text(
                                "Months ${benefit.months}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                benefit.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    // SizedBox(
                    //   height: 20,
                    // ),

                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Pricing Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.dark,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "poppins"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.cyan, width: 0.5)),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "You Pay",
                                    style: TextStyle(
                                        color: AppColors.dark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "₹ ${(currentProduct.price).toString()}",
                                    style: TextStyle(
                                        color: AppColors.dark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "* Amount payble is inclusive of taxes Terms & Conditions apply ",
                            style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 11,
                                color: AppColors.dark,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  Future<YoutubePlayer?> _loadVideo(String videoUrl) async {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
        flags: YoutubePlayerFlags(autoPlay: false),
      ),
    );
  }

  Widget _buildContent() {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return RefreshHelper.buildRefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        itemCount: myVideoUrls.length,
        itemBuilder: (context, index) {
          return FutureBuilder<YoutubePlayer?>(
            future: _loadVideo(myVideoUrls[index]),
            builder: (context, AsyncSnapshot<YoutubePlayer?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerListViewForYoutubeContent(itemCount: 4);
              } else {
                final player = snapshot.data;
                if (player != null) {
                  return YoutubePlayerBuilder(
                    player: player,
                    builder: (context, _) {
                      return Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 80,
                                width: 120,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: player,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Text(
                                      "Das ka dum-King reserach aug-22 Batch Day-1")),
                              Icon(Icons.lock_rounded),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return ShimmerListViewForYoutubeContent(itemCount: 4);
                }
              }
            },
          );
        },
      ),
    );
  }
}
// if (this.list != null) {
//       final dd = this
//           .list
//           ?.where((element) => element.id == productId)
//           .toList()[0]
//           .heartsCount = 1;

//       setState(() {
//         print("State Method Called");
//         this.list = dd as List<ProductResponseModel>?;
//       });
//     }