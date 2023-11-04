import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kraapp/app_color.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key});

  @override
  State<TradingScreen> createState() => _TradingScreen();
}

class _TradingScreen extends State<TradingScreen> {
  List<Map<String, dynamic>> _data = [];

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        data.forEach((item) {
          item['isFavorite'] = false;
        });
        setState(() {
          _data = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
              ..._data.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                bool _isFavorite = item['isFavorite'] ?? false;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: AppColors.lightShadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: AppColors.grey, width: 0.2),
                  ),
                  elevation: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            item['image'],
                            height: 150,
                            width: 100,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['category'],
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _data[index]['isFavorite'] = !_isFavorite;
                                    });
                                  },
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorite ? Colors.red : null,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: double.parse(
                                          item['rating']['rate'].toString()),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      ignoreGestures: true,
                                      itemSize: 18,
                                      onRatingUpdate: (double value) {},
                                    )
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  onPressed: () {},
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
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
