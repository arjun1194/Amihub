import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmizoneInterceptor extends InterceptorContract {
  AmizoneInterceptor();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      //TODO:test this internet checker
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences sharedPreferences = await SharedPreferences
              .getInstance();
          final jwtToken = sharedPreferences.get('Authorization');
          data.headers["Authorization"] = jwtToken;
        }
      } on SocketException catch (_) {
        print("No internet");
      }



    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async => data;
}
