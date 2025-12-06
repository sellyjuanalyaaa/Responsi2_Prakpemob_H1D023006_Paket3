import 'dart:convert';

import 'package:responsi2mobilepaket3h1d023006/helpers/api.dart';
import 'package:responsi2mobilepaket3h1d023006/helpers/api_url.dart';
import 'package:responsi2mobilepaket3h1d023006/model/login.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};
    var response = await Api().post(apiUrl, body);
    print('Login Response: ${response.body}'); // Debug
    var jsonObj = json.decode(response.body);
    return Login.fromJson(jsonObj);
  }
}
