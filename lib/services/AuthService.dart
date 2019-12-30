import 'dart:convert';
import 'dart:io';

import 'package:groupcon01/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static SharedPreferences sharedPreferences;
  static Future<Map<String, dynamic>> login(
      String _email, String _password) async {
    const URL = '$API_URI/api/v1/auth/login';
    var response =
        await http.post(URL, body: {'email': _email, 'password': _password});
    Map<String, dynamic> data = {
      'body': response.body,
      'statusCode': response.statusCode
    };
    return data;
  }

  static Future<User> currentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    var currentUserResponse = await http.get('$API_URI/api/v1/auth/current',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    var jsonData = json.decode(currentUserResponse.body);
    var currentUserJson = jsonData;
    User user = User.fromJson(currentUserJson);
    sharedPreferences.setString('currentUserId', user.id);

    return user;
  }

  static Future<String> currentUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString('currentUserId');
    return id;
  }

  static Future<Map<String, dynamic>> register(
      User user, String password) async {
    var response = await http.post('$API_URI/api/v1/user', body: {
      'email': user.email,
      'nickname': user.nickname,
      'password': password
    });
    var responseDeserialized = jsonDecode(response.body);
    Map<String, dynamic> res;

    if (response.statusCode == 200) {
      res = {
        'token': responseDeserialized['token'],
        'userId': responseDeserialized['userId'],
        'error': null
      };
    } else {
      res = {'error': responseDeserialized['error']};
    }

    return res;
  }
}
