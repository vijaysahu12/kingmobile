import 'package:flutter/material.dart';

import '../Constants/app_color.dart';

class NotificationEmptyScreen extends StatefulWidget {
  const NotificationEmptyScreen({super.key});

  @override
  State<NotificationEmptyScreen> createState() => _NotificationEmptyScreen();
}

class _NotificationEmptyScreen extends State<NotificationEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
