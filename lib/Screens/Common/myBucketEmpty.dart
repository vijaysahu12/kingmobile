import 'package:flutter/material.dart';

import '../Constants/app_color.dart';

class MyBucketScreen extends StatefulWidget {
  const MyBucketScreen({super.key});

  @override
  State<MyBucketScreen> createState() => _MyBucketScreen();
}

class _MyBucketScreen extends State<MyBucketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.light,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://static.vecteezy.com/system/resources/previews/003/274/389/original/no-notification-flat-illustration-vector.jpg',
                scale: 2,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Empty',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
