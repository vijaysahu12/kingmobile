import 'package:flutter/material.dart';
import '../../Helpers/sharedPref.dart';
import '../Constants/app_color.dart';

class AppBarBuilder {
  static SharedPref _sharedPref = SharedPref();

  static Future<String> loadUserName() async {
    String fullName = await _sharedPref.read("KingUserProfileName") ?? '';
    return fullName.replaceAll('"', '');
  }

  static AppBar buildAppBar(BuildContext context, int currentIndex) {
    return currentIndex == 3
        ? AppBar(
            backgroundColor: AppColors.purple,
            automaticallyImplyLeading: false,
          )
        : AppBar(
            backgroundColor: AppColors.purple,
            title: FutureBuilder<String>(
              future: loadUserName(),
              builder: (context, snapshot) {
                String _userName = snapshot.data ?? '';
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/person_logo.png'),
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightShadow,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications,
                        color: AppColors.lightShadow,
                      ),
                    ),
                  ],
                );
              },
            ),
            automaticallyImplyLeading: false,
          );
  }
}
