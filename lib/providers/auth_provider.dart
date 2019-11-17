import 'package:flutter/material.dart';
import 'package:groupcon01/services/AuthService.dart';

class AuthProvider extends ChangeNotifier {
  String _userId;

  String get userId {
    AuthService.currentUserId().then((id) {
      return id;
    });
  }
}
