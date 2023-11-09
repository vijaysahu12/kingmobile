import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:kraapp/Services/Helpers/prodUrl.dart';
import 'dart:convert';

import 'package:kraapp/app_color.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key});

  @override
  State<TradingScreen> createState() => _TradingScreen();
}

class _TradingScreen extends State<TradingScreen> {
  void _showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 130.0),
              height: 500,
              child: Dialog(
                backgroundColor: AppColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightShadow),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '  You have Successfully Completed \n your Registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightShadow),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(ApiConstants.getProducts));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool _isFavorite = true;

  // Future<void> fetchDataTwo() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('https://fakestoreapi.com/products'));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       data.forEach((item) {
  //         item['liked'] = false;
  //       });
  //       setState(() {
  //         data = List<Map<String, dynamic>>.from(data);
  //       });
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Algo Trading',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [Center(child: Text('wait a second'))],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> data = snapshot.data!;

                    return Container(
                      padding: EdgeInsets.only(bottom: 35),
                      height: constraints.maxHeight,
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.grey, width: 0.2)),
                                    child: Image.network(
                                      data[index]['image'] != null &&
                                              data[index]['image'].isNotEmpty
                                          ? data[index]['image']
                                          : 'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png',
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: Text(
                                                      //   item['name'],
                                                      data[index]['name'],
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  data[index]['liked'] =
                                                      !_isFavorite;
                                                });
                                              },
                                              child: Icon(
                                                _isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _isFavorite
                                                    ? Colors.red
                                                    : null,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          // item['description'],
                                          data[index]['description'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: double.parse(
                                                      data[index]['rating']
                                                          .toString()),
                                                  itemBuilder: (context, _) =>
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
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                              ),
                                              onPressed: () {
                                                _showPopUp(context);
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
                            );
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
