import 'dart:async';
// import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kraapp/Helpers/sharedPref.dart';

class HttpRequestHelper {
  SharedPref _sharedPref = SharedPref();

  Future<void> refreshData() async {
    await Future.delayed(
      Duration(seconds: 3),
    );
  }

  static Future<bool> checkInternetConnection(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No internet connection',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: Color.fromARGB(255, 234, 199, 146),
        ),
      );
      return false;
    }
    return true;
  }

  getWithOutToken(String url) async {
    return await http.get(
      Uri.parse(url),
    );
  }

  get(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + await _sharedPref.read("KingUserToken"),
      },
    );
  }

  Future<dynamic> post(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + await _sharedPref.read("KingUserToken"),
      },
    );

    // final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    // return Album.fromJson(responseJson);
  }
}


//testing vijay