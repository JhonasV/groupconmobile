import 'dart:convert';
import 'dart:io';

import 'package:groupcon01/models/group.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupService {
  static SharedPreferences sharedPreferences;

  static Future<void> create(Group group) async {
    final url = 'https://obscure-ridge-85508.herokuapp.com/api/v1/group';

    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    await http.post(url,
        body: {'name': group.name, 'url': group.url, 'password': ''},
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  }

  static Future<Map<String, List<Group>>> fetchLatestsGroups() async {
    final url = 'https://obscure-ridge-85508.herokuapp.com/api/v1/group';
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final bodyDecoded = json.decode(response.body);

      List<Group> groups = parseGroups(bodyDecoded['groups']);
      List<Group> latestGroups = parseGroups(bodyDecoded['latestGroups']);

      Map<String, List<Group>> result = {
        "latestGroups": latestGroups,
        "groups": groups
      };
      return result;
    } else {
      throw new Exception('Error fetching the data');
    }
  }

  static Future<List<Group>> userGroups() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String currentUserId = sharedPreferences.getString('currentUserId');

    final url =
        'https://obscure-ridge-85508.herokuapp.com/api/v1/${currentUserId}/groups';
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List<Group> groups = parseGroups(json.decode(response.body));
      return groups;
    } else {
      throw new Exception('Error fetching the data');
    }
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
