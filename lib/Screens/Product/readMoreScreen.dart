import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../practice.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productRating;
  final double productPrice;

  const ProductDetailsScreen(
    this.productName,
    this.productDescription,
    this.productRating,
    this.productPrice,
  );

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var isPaid = false;

  List<String> myVideoUrls = [
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
    'https://youtu.be/5f1U2AQLVo4?si=4rDzrBfHFPVV9wx7',
    'https://youtu.be/uR8Gc5htyr0?si=3sAtn-hIPmNrPvWE',
  ];

  final String videoUrl = 'https://youtu.be/uR8Gc5htyr0?si=6938x8gYU-qSXgUb';
  void openYoutubeVideo(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePlayerScreen(videoUrls: myVideoUrls),
      ),
    );
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
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 20.0,
          left: 15,
          right: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.productName,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.favorite_border_rounded)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            // productName,
                            "Category",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          RatingBar.builder(
                            initialRating:
                                double.parse(widget.productRating.toString()),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            itemSize: 25,
                            onRatingUpdate: (double value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    child: Image.network(
                      'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
                      height: 150,
                      width: 350,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(15)),
                  )
                ],
              ),
              // Divider(
              //   color: AppColors.grey,
              //   thickness: 2.0,
              // ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("About This Course",
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.productDescription,
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
              Divider(
                color: AppColors.grey,
                thickness: 3.0,
              ),

              Row(
                children: [
                  Column(
                    children: [
                      Image.network(
                        "https://th.bing.com/th/id/OIP.eeLDU71Mp-6xvipaupP3hQHaHX?w=199&h=198&c=7&r=0&o=5&pid=1.7",
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
                            "Facing any difficulties, Vijay Sahu?",
                            style: TextStyle(
                                fontSize: 14,
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
                                fontSize: 13,
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
                        border: Border.all(color: AppColors.cyan, width: 0.5)),
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
                              "₹ ${widget.productPrice}",
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
          ),
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
                "₹ ${widget.productPrice}",
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
                            '${(widget.productPrice * 100).toString()}', //RS 1 (100paisa=1)
                        'name': '${widget.productName}',
                        'description': '${widget.productDescription}',
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
                    openYoutubeVideo(context, videoUrl);
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
}
