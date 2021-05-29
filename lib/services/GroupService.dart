import 'dart:convert';
import 'dart:io';

import 'package:groupcon01/models/group.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class GroupService {
  static SharedPreferences sharedPreferences;

  static Future<void> create(Group group) async {
    final url = '$API_URI/api/v1/group';

    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    try {
      await http.post(url, body: {
        'name': group.name,
        'url': group.url,
        'password': group.password
      }, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      });
    } catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<Map<String, dynamic>> fetchLatestsGroups() async {
    final url = '$API_URI/api/v1/group';

    Map<String, dynamic> result;
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final bodyDecoded = json.decode(response.body);
        List<Group> groups = parseGroups(bodyDecoded['groups']);
        List<Group> latestGroups = parseGroups(bodyDecoded['latestGroups']);
        result = {"latestGroups": latestGroups, "groups": groups};
      } else {
        result = {"latestGroups": List<Group>(), "groups": List<Group>()};
      }
    } on SocketException {
      result = {'error': "No Internet Connection"};
    } on HttpException {
      result = {'error': 'No Service Found'};
    } on FormatException {
      result = {'error': 'Invalid Data Format'};
    } catch (e) {
      result = {'error': e.message.toString()};
    }
    return result;
  }

  static Future<Map<String, dynamic>> userGroups() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String currentUserId = sharedPreferences.getString('currentUserId');

    final url = '$API_URI/api/v1/$currentUserId/groups';
    Map<String, dynamic> result;

    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        List<Group> groups = parseGroups(json.decode(response.body));
        result = {'groups': groups};
      } else {
        result = {'groups': List<Group>()};
      }
    } on SocketException {
      result = {'error': "No Internet Connection", 'groups': List<Group>()};
    } on HttpException {
      result = {'error': 'No Service Found', 'groups': List<Group>()};
    } on FormatException {
      result = {'error': 'Invalid Data Format', 'groups': List<Group>()};
    } catch (e) {
      result = {'error': e.message.toString(), 'groups': List<Group>()};
    }
    return result;
  }

  static Future<Map<String, dynamic>> deleteGroup(String groupId) async {
    final url = '$API_URI/api/v1/group/$groupId';

    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    Map<String, dynamic> result;
    try {
      http.Response response = await http.delete(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var responseDeserialized = json.decode(response.body);
        result = {'removed': responseDeserialized['removed']};
      } else {
        result = {'removed': false};
      }
    } on SocketException {
      result = {'error': "No Internet Connection"};
    } on HttpException {
      result = {'error': 'No Service Found'};
    } on FormatException {
      result = {'error': 'Invalid Data Format'};
    } catch (e) {
      result = {'error': e.message.toString()};
    }
    return result;
  }

  static Future<Map<String, dynamic>> updateGroup(
      Group group, String password) async {
    final url = '$API_URI/api/v1/${group.id}/group';

    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    Map<String, dynamic> result;
    try {
      http.Response response = await http.put(url,
          body: {'name': group.name, 'url': group.url, 'password': password},
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      final responseDeserialized = json.decode(response.body);

      if (response.statusCode == 200) {
        result['updated'] = true;
      } else {
        result = {'updated': false, 'error': responseDeserialized['error']};
      }
    } on SocketException {
      result = {'error': "No Internet Connection"};
    } on HttpException {
      result = {'error': 'No Service Found'};
    } on FormatException {
      result = {'error': 'Invalid Data Format'};
    } catch (e) {
      result = {'error': e.message.toString()};
    }
    return result;
  }

  static List<Group> parseGroups(dynamic responseBody) {
    // final parsed = json.decode(responseBody);
    return responseBody.map<Group>((json) => Group.fromJson(json)).toList();
  }

  static List<Group> parseCurrentUserGroups(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed.map<Group>((json) => Group.fromJson(json)).toList();
  }
}
