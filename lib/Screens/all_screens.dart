// import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kraapp/Screens/community_group.dart';
import 'package:kraapp/Screens/home_screen.dart';
import 'package:kraapp/Screens/personal_screen.dart';
import 'package:kraapp/Screens/trading_screen.dart';
import 'package:kraapp/app_bar.dart';

import 'package:kraapp/bottom_navigationbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(User user, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, _currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Personal(),
          TradingScreen(),
          CommunityGroup(),
          PersonalInformation(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
