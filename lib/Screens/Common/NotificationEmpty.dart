import 'package:flutter/material.dart';

import '../Constants/app_color.dart';

class DataEmptyScreen extends StatefulWidget {
  const DataEmptyScreen({super.key});

  @override
  State<DataEmptyScreen> createState() => _DataEmptyScreen();
}

class _DataEmptyScreen extends State<DataEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.light,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/notificationEmpty.png',
                scale: 2,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'No notifications',
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
