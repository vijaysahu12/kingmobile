import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../Common/refreshtwo.dart';
import '../Constants/app_color.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationsScreen> {
  // bool isSwitched = false;

  Widget slidingSwitch(Function(bool) onSwitchChanged) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.primaryColor, width: 1)),
      child: Row(
        children: [
          SlidingSwitch(
              value: false,
              onChanged: onSwitchChanged,
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              height: 29,
              width: 58,
              animationDuration: Duration(milliseconds: 200),
              textOn: '',
              textOff: '',
              buttonColor: AppColors.primaryColor),
        ],
      ),
    );
  }

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
      body: RefreshHelper.buildRefreshIndicator(
        onRefresh: RefreshHelper.defaultOnRefresh,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            // physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w800,
                            color: AppColors.purple),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightShadow,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dark, width: 2))),
                          child: Row(
                            children: [
                              Text(
                                'News',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey),
                              ),
                              Spacer(),
                              slidingSwitch((p0) {}),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dark, width: 2))),
                          child: Row(
                            children: [
                              Text(
                                'Community',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey),
                              ),
                              Spacer(),
                              slidingSwitch((p0) => {}),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dark, width: 2))),
                          child: Row(
                            children: [
                              Text(
                                'Weekly Price Updates',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey),
                              ),
                              Spacer(),
                              slidingSwitch((p0) => {}),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dark, width: 2))),
                          child: Row(
                            children: [
                              Text(
                                'Account Updates',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey),
                              ),
                              Spacer(),
                              slidingSwitch((p0) => {}),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Text(
                                'Groups',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey),
                              ),
                              Spacer(),
                              slidingSwitch((p0) => {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
