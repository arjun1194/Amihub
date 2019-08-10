import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AmizoneInterceptor extends InterceptorContract{
  final jwtToken;

  AmizoneInterceptor(this.jwtToken);
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      data.headers["Authorization"] = jwtToken;
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data})  async => data;

}