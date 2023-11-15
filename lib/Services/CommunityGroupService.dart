import 'dart:convert';

import 'package:kraapp/Helpers/dio.dart';

import '../Helpers/ApiUrls.dart';
import '../Models/Response/CommunityGroupResponse.dart';

class CommunityGroupService {
  ApiServiceTwo _apiService = ApiServiceTwo();
  Future<List<CommunityGroupResponse>?> getProductDetails() async {
    List<CommunityGroupResponse>? list = null;
    final dynamic result = await _apiService.get(ApiUrlConstants.getProducts);
    if (result != null) {
      final List parsedList = json.decode(result);
      list = parsedList
          .map((val) => CommunityGroupResponse.fromJson(val))
          .toList();
      print(list);
    }
    return list;
  }
}
