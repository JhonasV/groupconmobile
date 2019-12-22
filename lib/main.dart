import 'package:flutter/material.dart';
import 'package:groupcon01/providers/auth_provider.dart';
import 'package:groupcon01/screens/dashboard_screen.dart';
import 'package:groupcon01/screens/register_screen.dart';
import 'package:provider/provider.dart';

import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'GroupCon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          DashboardScreen.id: (context) => DashboardScreen(),
          RegisterScreen.id: (context) => RegisterScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
