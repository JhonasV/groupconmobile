import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';

class GroupProvider with ChangeNotifier {
  List<Group> _groups = [
    Group(id: '646546sadasd', name: 'hola', url: 'url', user: 'uff'),
    Group(id: '646546sada', name: 'klk', url: 'url', user: 'uff'),
    Group(id: '646546s', name: 'todo bien', url: 'url', user: 'uff'),
  ];

  List<Group> get groups {
    return _groups;
  }

  set groups(List<Group> groups) {
    this._groups = groups;

    notifyListeners();
  }
}
