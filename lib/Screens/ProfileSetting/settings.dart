import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../Constants/app_color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.lightShadow,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.grey, width: 1)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Two Factor Athentication',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            child: Row(
                              children: [
                                SlidingSwitch(
                                    value: isSwitched,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    },
                                    onTap: () {},
                                    onDoubleTap: () {},
                                    onSwipe: () {},
                                    height: 30,
                                    width: 60,
                                    textOff: '',
                                    textOn: '',
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    buttonColor: isSwitched
                                        ? AppColors.primaryColor
                                        : AppColors.cyan),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Update Password',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Profile  ',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
