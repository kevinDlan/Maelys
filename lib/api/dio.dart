import 'package:dio/dio.dart';
import 'package:maelys_imo/constant/app_constant.dart';

Dio dio() {
  Dio dio = Dio(
    BaseOptions(
        baseUrl: apiBaseUrl,
        responseType: ResponseType.plain,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json'
        }),
  );
  return dio;
}
