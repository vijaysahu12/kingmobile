import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyBucketScreen extends StatefulWidget {
  const MyBucketScreen({super.key});
  @override
  State<MyBucketScreen> createState() => _MyBucketScreen();
}

class _MyBucketScreen extends State<MyBucketScreen> {
  late List<dynamic> dataList;
  int currentPage = 1;
  final int perPage = 10;

  @override
  void initState() {
    super.initState();
    dataList = [];
    loadInitailData();
  }

  void loadInitailData() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
    if (response.statusCode == 200) {
      setState(() {
        dataList = json.decode(response.body);
      });
    }
  }

  void loadMoreData() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
    if (response.statusCode == 200) {
      setState(() {
        dataList.addAll(json.decode(response.body));
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataList[index]['name']),
                  subtitle: Text(dataList[index]['email']),
                );
              }),
        ),
        ElevatedButton(
          onPressed: loadMoreData,
          child: Text('Load More'),
        ),
      ]),
    );
  }
}
