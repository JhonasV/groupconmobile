import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/screens/create_screen.dart';
import 'package:groupcon01/screens/dashboard_screen.dart';
import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/screens/login_screen.dart';
import 'package:groupcon01/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  SharedPreferences sharedPreferences;
  bool isAutenticated = false;
  _isAutenticated() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    setState(() => isAutenticated = token != null);
  }

  @override
  void initState() {
    // TODO: implement initState
    _isAutenticated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100.0,
              width: double.infinity,
              child: DrawerHeader(
                child: Text(
                  'GroupCon',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed(HomeScreen.id);
              },
            ),
            isAutenticated
                ? _showDrawerMenuAutenticatedOptions()
                : _showDrawerMenuGuessOptions(),
          ],
        ),
      ),
    );
  }

  _showDrawerMenuAutenticatedOptions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(FontAwesomeIcons.chartBar),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(DashboardScreen.id);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.plusCircle),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'New Group',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => CreateScreen()));
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          onTap: () => _logout(),
        ),
      ],
    );
  }

  _showDrawerMenuGuessOptions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(FontAwesomeIcons.signInAlt),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, LoginScreen.id);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.userAlt),
          trailing: Icon(Icons.chevron_right),
          title: Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RegisterScreen.id);
          },
        ),
      ],
    );
  }

  _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
