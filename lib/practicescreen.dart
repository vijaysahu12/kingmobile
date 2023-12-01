// FutureBuilder<List<ProductResponseModel>?>(
//   future: productsFuture,
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting ||
//         snapshot.hasError) {
//       return ShimmerListViewForListofItems(itemCount: 7);
//     } else {
//       List<ProductResponseModel> data = snapshot.data!;

//       return FutureBuilder(
//         future: Future.wait(
//           List.generate(data.length, (index) {
//             return Future.delayed(Duration(seconds: index), () {
//               return Card(
//                 margin:
//                     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 color: AppColors.lightShadow,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                   side: BorderSide(color: AppColors.grey, width: 0.2),
//                 ),
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 3),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                         children: [
//                                               Container(
//                                                 margin:
//                                                     const EdgeInsets.all(5.0),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   border: Border.all(
//                                                       color: AppColors.grey,
//                                                       width: 0.2),
//                                                 ),
//                                                 child: Image.network(
//                                                   // data[index].image != null &&
//                                                   //         data[index].image.isNotEmpty
//                                                   //     ? data[index]['image']
//                                                   //     :
//                                                   //
//                                                   'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
//                                                   height: 100,
//                                                   width: 100,
//                                                 ),
//                                               ),
//                                               SizedBox(width: 10),
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Flexible(
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Container(
//                                                                 width: double
//                                                                     .infinity,
//                                                                 child: Text(
//                                                                   data[index]
//                                                                       .name,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: AppColors
//                                                                         .primaryColor,
//                                                                     fontSize:
//                                                                         14,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             setState(() {
//                                                               isFavoriteList[
//                                                                       index] =
//                                                                   !isFavoriteList[
//                                                                       index];
//                                                             });
//                                                           },
//                                                           child: Icon(
//                                                             isFavoriteList[
//                                                                     index]
//                                                                 ? Icons.favorite
//                                                                 : Icons
//                                                                     .favorite_border,
//                                                             color:
//                                                                 isFavoriteList[
//                                                                         index]
//                                                                     ? Colors.red
//                                                                     : null,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: Text(
//                                                             data[index]
//                                                                 .description,
//                                                             style: TextStyle(
//                                                               fontSize: 12,
//                                                               color: AppColors
//                                                                   .grey,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 30,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Column(
//                                                           children: [
//                                                             RatingBar.builder(
//                                                               initialRating: double
//                                                                   .parse(data[
//                                                                           index]
//                                                                       .raiting
//                                                                       .toString()),
//                                                               itemBuilder:
//                                                                   (context,
//                                                                           _) =>
//                                                                       Icon(
//                                                                 Icons.star,
//                                                                 color: Colors
//                                                                     .amber,
//                                                               ),
//                                                               ignoreGestures:
//                                                                   true,
//                                                               itemSize: 18,
//                                                               onRatingUpdate:
//                                                                   (double
//                                                                       value) {},
//                                                             )
//                                                           ],
//                                                         ),
//                                                         Spacer(),
//                                                         TextButton(
//                                                           style: TextButton
//                                                               .styleFrom(
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           25),
//                                                             ),
//                                                             // backgroundColor:
//                                                             //     AppColors
//                                                             //         .primaryColor,
//                                                           ),
//                                                           onPressed: () {
//                                                             String productName =
//                                                                 data[index]
//                                                                     .name;
//                                                             String
//                                                                 productDescription =
//                                                                 data[index]
//                                                                     .description;
//                                                             String
//                                                                 productRating =
//                                                                 data[index]
//                                                                     .raiting;
//                                                             double
//                                                                 productPrice =
//                                                                 data[index]
//                                                                     .price;
//                                                             Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                   builder: (context) => ProductDetailsScreen(
//                                                                       productName,
//                                                                       productDescription,
//                                                                       productRating,
//                                                                       productPrice),
//                                                                 ));
//                                                           },
//                                                           child: Text(
//                                                             'Read More...',
//                                                             style: TextStyle(
//                                                                 color: AppColors
//                                                                     .primaryColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
                                        
//                     ],
//                   ),
//                 ),
//               );
//             });
//           }),
//         ),
//         builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Show a loader while waiting
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No Data'); // Handle empty data case
//           } else {
//             return ListView(
//               children: snapshot.data!, // Display the list of cards
//             );
//           }
//         },
//       );
//     }
//   },
// );
