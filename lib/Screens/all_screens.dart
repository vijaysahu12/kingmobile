import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:kraapp/Screens/CommunityGroup/communityGroup.dart';

import 'package:kraapp/Screens/ProfileSetting/profileDetailScreen.dart';

// import 'package:kraapp/Screens/Common/app_bar.dart';

import 'package:kraapp/Screens/Common/bottom_navigationbar.dart';

import '../Helpers/httpRequest.dart';
import '../Helpers/ApiUrls.dart';
import '../Helpers/sharedPref.dart';

import 'Common/app_bar.dart';
import 'Home/home_screen.dart';
import 'Product/productScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  HttpRequestHelper _httpHelper = HttpRequestHelper();
  int _currentIndex = 0;
  final _pagesView = [
    Personal(),
    TradingScreen(),
    CommunityGroup(),
    PersonalInformation()
  ];
  final _pageController = PageController();

  // void _onTabTapped(int index) {
  //   _httpHelper.checkInternetConnection(context);
  //   setState(() {
  //     _currentIndex = index;
  //     _pageController.animateToPage(_currentIndex,
  //         duration: const Duration(milliseconds: 200), curve: Curves.linear);
  //   });
  // }

  Future<List> GetProducts() async {
    final apiUrl = ApiUrlConstants.baseUrl + ApiUrlConstants.getProducts;
    final response = await _httpHelper.get(apiUrl);

    SharedPref _sharedPref = new SharedPref();

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
      //appBar: buildAppBar(context, _currentIndex),
      appBar: AppBarBuilder.buildAppBar(context, _currentIndex),
      body: PageView(
        // ignore: sort_child_properties_last
        children: _pagesView,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          _httpHelper.checkInternetConnection(context);
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(_currentIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
      ),
    );
  }
}
