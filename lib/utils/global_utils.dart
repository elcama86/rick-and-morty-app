import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GlobalUtils {
  int getCurrentPage(String url) {
    return int.parse(url.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  Future<dynamic> getData(String url) async {
    try {
      final dio = Dio();

      final response = await dio.get(url);

      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio error!');
        debugPrint('STATUS: ${e.response?.statusCode}');
        debugPrint('DATA: ${e.response?.data}');
        debugPrint('HEADERS: ${e.response?.headers}');
      } else {
        debugPrint('Error sending request!');
        debugPrint(e.message);
      }
    }
  }
}
