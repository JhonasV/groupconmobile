import 'dart:convert';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String _email, String _password) async {
    // final URL = 'http://10.0.2.2:5000/api/v1/auth/login';
    final URL = 'https://obscure-ridge-85508.herokuapp.com/api/v1/auth/login';
    var response =
        await http.post(URL, body: {'email': _email, 'password': _password});
    Map<String, dynamic> data = {
      'body': response.body,
      'statusCode': response.statusCode
    };
    return data;
  }
}
