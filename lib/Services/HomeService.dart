import 'dart:convert';

import 'package:kraapp/Helpers/dio.dart';

import '../Helpers/ApiUrls.dart';
import '../Models/Response/HomeResponse.dart';

class HomeService {
  ApiServiceTwo _apiService = ApiServiceTwo();
  Future<List<HomeResponse>?> getProductDetails() async {
    List<HomeResponse>? list = null;
    final dynamic result = await _apiService.get(ApiUrlConstants.getProducts);
    if (result != null) {
      final List parsedList = json.decode(result);
      list = parsedList.map((val) => HomeResponse.fromJson(val))
          as List<HomeResponse>;
      print(list);
    }
    return list;
  }
}
