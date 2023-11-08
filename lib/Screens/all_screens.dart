// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:kraapp/Screens/community_group.dart';
import 'package:kraapp/Screens/home_screen.dart';
import 'package:kraapp/Screens/personal_screen.dart';
import 'package:kraapp/Screens/trading_screen.dart';
import 'package:kraapp/Services/Helpers/httpRequest.dart';
import 'package:kraapp/Services/Helpers/sharedPref.dart';
import 'package:kraapp/app_bar.dart';

import 'package:kraapp/bottom_navigationbar.dart';
import 'package:kraapp/Services/Helpers/prodUrl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;
  HttpRequestHelper _httpHelper = HttpRequestHelper();
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<List> GetProducts() async {
    final apiUrl = ApiConstants.baseUrl + ApiConstants.getProducts;
    final response = await _httpHelper.get(apiUrl);

    SharedPref _sharedPref = SharedPref();

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('statusCode') &&
          jsonResponse['statusCode'] == 200) {
        _sharedPref.save("KingUserId", jsonResponse['data']["publicKey"]);
        _sharedPref.save("KingUserToken", jsonResponse['data']["token"]);
        _sharedPref.save("KingUserProfileImage", jsonResponse['data']["image"]);

        print(jsonResponse['data']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        String errorMessage = jsonResponse['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print('API Request Failed with status code: ${response.statusCode}');
    }

    return [];
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
