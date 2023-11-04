import 'package:flutter/material.dart';
import 'package:kraapp/app_color.dart';

AppBar buildAppBar(BuildContext context, int currentIndex) {
  if (currentIndex == 3) {
    return AppBar(
      backgroundColor: AppColors.purple,
      automaticallyImplyLeading: false,
    );
  } else {
    return AppBar(
      backgroundColor: AppColors.purple,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('images/seshi.jpg'),
            radius: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Seshadri Kaku',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightShadow,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
