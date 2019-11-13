import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Response> login(String _email, String _password) async {
    var response = await http.post('http://10.0.2.2:5000/api/v1/auth/login',
        body: {'email': _email, 'password': _password});

    return response;
  }
}
