import 'dart:async';
// import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kraapp/Services/Helpers/sharedPref.dart';

class HttpRequestHelper {
  SharedPref _sharedPref = SharedPref();

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
            "Bearer " + _sharedPref.read("KingUserToken"),
      },
    );
  }

  Future<dynamic> Post(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + _sharedPref.read("KingUserToken"),
      },
    );

    // final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    // return Album.fromJson(responseJson);
  }
}


//testing vijay