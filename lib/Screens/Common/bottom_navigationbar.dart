import 'package:flutter/material.dart';

import '../Constants/app_color.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.home_outlined,
              color:
                  currentIndex == 0 ? AppColors.primaryColor : AppColors.grey,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.card_travel_outlined,
              color:
                  currentIndex == 1 ? AppColors.primaryColor : AppColors.grey,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.language_outlined,
              color:
                  currentIndex == 2 ? AppColors.primaryColor : AppColors.grey,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.person_outline_rounded,
              color:
                  currentIndex == 3 ? AppColors.primaryColor : AppColors.grey,
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
