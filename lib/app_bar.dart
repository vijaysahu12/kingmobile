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
            backgroundImage: NetworkImage(
                'https://cdn0.iconfinder.com/data/icons/flat-ui-5/64/img-jpg-bmp-picture-gallery-256.png'),
            radius: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'User Name',
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
