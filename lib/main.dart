import 'package:flutter/material.dart';
import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  SharedPreferences sharedPreferences;

  _isAutenticated() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      return true;
    }
    return false;
  }

  _renderHomeScreen() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(autenticated: _isAutenticated()),
        LoginScreen.id: (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
