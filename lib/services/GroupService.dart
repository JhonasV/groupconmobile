import 'dart:convert';

import 'package:groupcon01/models/group.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static Future<List<Group>> fetchLatestsGroups() async {
    String URL = 'http://10.0.0.10:5000/api/v1/group';
    // String URL = 'http://10.0.2.2:5000/api/v1/group';
    final response = await http.get(URL, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      List<Group> groups = [];
      List<Group> latestGroups = [];

      for (var g in jsonData['groups']) {
        // Group group = Group(name: g['name'], url: g['url'], id: g['_id']);
        Group group = Group.fromJson(g);
        groups.add(group);
      }

      // for (var g in jsonData['latestGroups']) {
      //   // Group group = Group(name: g['name'], url: g['url'], id: g['_id']);
      //   Group group = Group.fromJson(g);
      //   latestGroups.add(group);
      // }
      // Map groupMap = {'groups': groups, 'latestGroups': latestGroups};
      // var groupsJson = jsonData['groups'];
      // groupsJson.map((groupJson) => groups.add(Group.fromJson(groupJson)));
      // var latestGroupsJson = jsonData['latestGroups'];
      // latestGroupsJson
      //     .map((groupJson) => latestGroups.add(Group.fromJson(groupJson)));

      // var groupArrays = {groups, latestGroups};
      return groups;
    } else {
      throw new Exception('Error fetching the data');
    }
  }
}
