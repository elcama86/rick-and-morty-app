import 'package:dio/dio.dart';

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
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }
  }
}
