// import 'dart:convert';
import 'dart:convert';

import 'package:kraapp/Helpers/dio.dart';

import '../Helpers/ApiUrls.dart';
import '../Models/Response/ProductResponseModel.dart';

class ProductService {
  ApiServiceTwo _apiService = ApiServiceTwo();
  Future<List<ProductResponseModel>?> getProductDetails() async {
    // // ApiResponse<ProductResponseModel> response =
    // //     await _apiService.get<ProductResponseModel>(
    // //   ApiUrlConstants.getProducts,
    // //   (json) => ProductResponseModel.fromJson(json),
    // // );

    // // if (response.statusCode == 200) {
    // //   return response.data;
    // // } else {
    // //   return null;
    // // }
    List<ProductResponseModel>? list = null;
    final dynamic result = await _apiService.get(ApiUrlConstants.getProducts);
    if (result != null) {
      final List parsedList = json.decode(result);
      list =
          parsedList.map((val) => ProductResponseModel.fromJson(val)).toList();
      print(list);
    }
    return list;
  }
}
