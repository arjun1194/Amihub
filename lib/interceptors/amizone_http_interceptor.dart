import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmizoneInterceptor extends InterceptorContract {
  AmizoneInterceptor();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Doing network call for ${data.url}');
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final jwtToken = sharedPreferences.get('Authorization');
      data.headers["Authorization"] = jwtToken;
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
