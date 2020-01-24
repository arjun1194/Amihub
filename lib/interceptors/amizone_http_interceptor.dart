import 'package:amihub/repository/amizone_repository.dart';
import 'package:amihub/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmizoneInterceptor extends InterceptorContract {
  AmizoneInterceptor();

  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final jwtToken = sharedPreferences.get('Authorization');
      data.headers["Authorization"] = jwtToken;
//      print(jwtToken);
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    if (data.headers['Authorization'] != null) {
      await SharedPreferences.getInstance().then((sp) {
        sp.setString("Authorization", data.headers['Authorization']);
      });
    }

    if (data.statusCode == 401) {
      amizoneRepository.logout(navKey.currentContext);
      navKey.currentState
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
    if (data.statusCode == 420) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool('appDown', true);
      navKey.currentState
          .pushNamedAndRemoveUntil('/down', (Route<dynamic> route) => false);
    }
    return data;
  }
}
