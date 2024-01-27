import 'package:flutter/material.dart';

import '../Constants/app_color.dart';

class MyBucketScreenEmpty extends StatefulWidget {
  const MyBucketScreenEmpty({super.key});

  @override
  State<MyBucketScreenEmpty> createState() => _MyBucketScreenEmpty();
}

class _MyBucketScreenEmpty extends State<MyBucketScreenEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.light,
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://static.vecteezy.com/system/resources/previews/003/274/389/original/no-notification-flat-illustration-vector.jpg',
              scale: 2,
            ),
            Container(
              child: Text(
                'Empty Bucket List',
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
    );
  }
}
