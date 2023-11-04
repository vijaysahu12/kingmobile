import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kraapp/app_color.dart';

class CommunityGroup extends StatefulWidget {
  const CommunityGroup({super.key});

  @override
  State<CommunityGroup> createState() => _CommunityGroup();
}

class _CommunityGroup extends State<CommunityGroup> {
  bool isCommunitySelected = true;
  String apiUrl = 'https://fakestoreapi.com/products';

  Future<List<Map<String, dynamic>>> fetchData() async {
    String url;
    if (isCommunitySelected) {
      url = apiUrl;
    } else {
      url = apiUrl;
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
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

                  return Column(
                    children: [
                      if (isCommunitySelected)
                        Expanded(
                          child: ListView.builder(
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
                                    data[index]['image'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (!isCommunitySelected)
                        Expanded(
                          child: ListView.builder(
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
                                          '${data[index]['image']}',
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${data[index]['category']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${data[index]['title']}',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
