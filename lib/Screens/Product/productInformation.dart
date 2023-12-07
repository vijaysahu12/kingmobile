// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// import '../Constants/app_color.dart';

// class ProductInformation extends StatefulWidget {
//   final String productName;
//   final String productDescription;
//   final String productRating;
//   final double productPrice;
//   final String productCategory;

//   const ProductInformation(
//     this.productName,
//     this.productDescription,
//     this.productRating,
//     this.productPrice,
//     this.productCategory,
//   );

//   @override
//   State<ProductInformation> createState() => _ProductInformation();
// }

// class _ProductInformation extends State<ProductInformation> {
//   late PageController _pageController;
//   var isPaid = false;
//   bool isCommunitySelected = true;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppColors.purple,
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: AppColors.lightShadow,
//               )),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(left: 15, right: 15),
//           child: Column(
//             children: [
//               Container(
//                 margin:
//                     EdgeInsets.only(top: 10, bottom: 2, left: 18, right: 18),
//                 decoration: BoxDecoration(
//                     color: AppColors.lightShadow,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           isCommunitySelected = true;
//                           _pageController.animateToPage(0,
//                               duration: Duration(milliseconds: 300),
//                               curve: Curves.ease);
//                         });
//                       },
//                       style: TextButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor:
//                               isCommunitySelected ? AppColors.light : null,
//                           padding: EdgeInsets.symmetric(horizontal: 45)),
//                       child: Text(
//                         'Overview',
//                         style: TextStyle(
//                             color: isCommunitySelected
//                                 ? AppColors.primaryColor
//                                 : AppColors.grey,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           isCommunitySelected = false;
//                           _pageController.animateToPage(1,
//                               duration: Duration(milliseconds: 300),
//                               curve: Curves.ease);
//                         });
//                       },
//                       style: TextButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor:
//                               !isCommunitySelected ? AppColors.light : null,
//                           padding: EdgeInsets.symmetric(horizontal: 45)),
//                       child: Text(
//                         'Content',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: !isCommunitySelected
//                                 ? AppColors.primaryColor
//                                 : AppColors.grey),
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   onPageChanged: (index) {
//                     setState(() {
//                       isCommunitySelected = index == 0;
//                     });
//                   },
//                   children: [
//                     _buildOverviewContent(),
//                     _buildContent(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           color: AppColors.purple,
//           child: Container(
//             height: 60,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "₹ ${widget.productPrice}",
//                   style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.lightShadow),
//                 ),
//                 if (isPaid)
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 35),
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         //Razorpay razorpay = Razorpay();
//                         // var options = {
//                         //   'key': 'rzp_test_8x2It6dJUckx0i',
//                         //   'amount':
//                         //       '${(widget.productPrice * 100).toString()}', //RS 1 (100paisa=1)
//                         //   'name': '${widget.productName}',
//                         //   'description': '${widget.productDescription}',
//                         //   'retry': {'enabled': true, 'max_count': 1},
//                         //   'send_sms_hash': true,
//                         //   'prefill': {
//                         //     'contact': '6309373318',
//                         //     'email': 'kakuseshadri033@gmail.com'
//                         //   },
//                         //   'external': {
//                         //     'wallets': ['paytm']
//                         //   }
//                         // };
//                         // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//                         //     paymentSuccessResponse);
//                         // razorpay.on(
//                         //     Razorpay.EVENT_PAYMENT_ERROR, paymentFailureResponse);
//                         // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
//                         //     handleExternalWalletSelected);
//                         // razorpay.open(options);
//                         Navigator.pop(context);
//                       });
//                     },
//                     child: Text(
//                       "Buy Now",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.lightShadow,
//                       ),
//                     ),
//                   ),
//                 if (isPaid != true)
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 35),
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     onPressed: () {
//                       // openYoutubeVideo(context, videoUrl);
//                     },
//                     child: Text(
//                       "Open",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.lightShadow,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildOverviewContent() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Column(
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         widget.productName,
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: AppColors.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   Column(
//                     children: [
//                       Icon(Icons.favorite_border_rounded),
//                     ],
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         widget.productCategory,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: AppColors.grey,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   Column(
//                     children: [
//                       RatingBar.builder(
//                         initialRating:
//                             double.parse(widget.productRating.toString()),
//                         itemBuilder: (context, _) => Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                         ),
//                         ignoreGestures: true,
//                         itemSize: 25,
//                         onRatingUpdate: (double value) {},
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     child: Image.network(
//                       'https://i0.wp.com/lindaraschke.net/wp-content/uploads/forex-banner-1000x350.jpg?fit=1000%2C350&ssl=1',
//                       height: 150,
//                       width: 300,
//                     ),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.grey, width: 0.5),
//                         borderRadius: BorderRadius.circular(15)),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text("About This Course",
//                           style: TextStyle(
//                               fontSize: 17,
//                               fontFamily: "poppins",
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.dark))
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           widget.productDescription,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: AppColors.grey,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       Icon(
//                         Icons.access_time_rounded,
//                         size: 30,
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "6 Months Validity",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontFamily: "poppins",
//                                 fontWeight: FontWeight.w600),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             "You will get this course for 6 full Month(s)",
//                             style: TextStyle(
//                                 color: AppColors.grey,
//                                 fontSize: 12,
//                                 fontFamily: "poppins",
//                                 fontWeight: FontWeight.w600),
//                           )
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               InkWell(
//                 onTap: () {
//                   // openYoutubeVideo(context, videoUrl);
//                 },
//                 child: Row(
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: AppColors.primaryColor),
//                           child: Icon(
//                             Icons.play_arrow_rounded,
//                             size: 30,
//                             color: AppColors.light,
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "6 Learning Material",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontFamily: "poppins",
//                                   fontWeight: FontWeight.w600),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "6  Video lectures",
//                               style: TextStyle(
//                                   color: AppColors.grey,
//                                   fontSize: 12,
//                                   fontFamily: "poppins",
//                                   fontWeight: FontWeight.w600),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     Spacer(),
//                     Column(
//                       children: [
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 20,
//                           color: AppColors.dark,
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Divider(
//                 color: AppColors.grey,
//                 thickness: 3.0,
//               ),
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       Image.asset(
//                         "images/cloudQuestion.jpg",
//                         height: 50,
//                         width: 50,
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Facing any difficulties,{_userName}?",
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontFamily: "poppins",
//                                 fontWeight: FontWeight.w600),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: Text(
//                               'Talk to me instantly',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               Divider(
//                 color: AppColors.grey,
//                 thickness: 3.0,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "Pricing Details",
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: AppColors.dark,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "poppins"),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: AppColors.cyan, width: 0.5)),
//                     child: Row(
//                       children: [
//                         Column(
//                           children: [
//                             Text(
//                               "You Pay",
//                               style: TextStyle(
//                                   color: AppColors.dark,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600),
//                             )
//                           ],
//                         ),
//                         Spacer(),
//                         Column(
//                           children: [
//                             Text(
//                               "₹ ${widget.productPrice}",
//                               style: TextStyle(
//                                   color: AppColors.dark,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Text(
//                       "* Amount payble is inclusive of taxes Terms & Conditions apply ",
//                       style: TextStyle(
//                           fontFamily: "poppins",
//                           fontSize: 11,
//                           color: AppColors.dark,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Row(
//             children: [Text("jdshvbnfdbcbhjbfvhhjb vhbsdvhydvdhsvbhdsvbvf")],
//           )
//         ],
//       ),
//     );
//   }
// }
