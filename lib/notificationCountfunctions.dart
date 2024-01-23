import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kraapp/Helpers/ApiUrls.dart';

import 'Helpers/sharedPref.dart';
import 'Screens/Common/useSharedPref.dart';

SharedPref _sharedPref = SharedPref();
UsingHeaders usingHeaders = UsingHeaders();

Future<int?> NotificationList() async {
  final String userKey = await _sharedPref.read(SessionConstants.UserKey);
  String mobileKey = userKey.replaceAll('"', '');
  UsingSharedPref usingSharedPref = UsingSharedPref();
  final jwtToken = await usingSharedPref.getJwtToken();
  Map<String, String> headers = usingHeaders.createHeaders(jwtToken: jwtToken);
  final String apiUrl = '${ApiUrlConstants.GetNotifications}';
  final Map<String, dynamic> requestBody = {
    "id": 0,
    "pageSize": 100,
    "pageNumber": 1,
    "requestedBy": mobileKey
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final dynamic jsonResponse = await jsonDecode(response.body);

    if (jsonResponse.containsKey('data') &&
        jsonResponse['data'] != null &&
        jsonResponse['data']['unReadCount'] != null) {
      final int parsedCount = jsonResponse['data']['unReadCount'] as int;
      print(parsedCount);

      return parsedCount;
    }
    return 0;
  } else {
    print('Request failed with status: ${response.statusCode}');
    throw Exception('Failed to load notifications');
  }
}
