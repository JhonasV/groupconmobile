import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/screens/login_screen.dart';
import 'package:groupcon01/services/GroupService.dart';
import 'package:groupcon01/widgets/group_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static final String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Group>> groups;

  SharedPreferences sharedPreferences;
  bool isAutenticated = false;

  @override
  void initState() {
    super.initState();
    groups = GroupService.fetchLatestsGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GroupCon'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
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
                Navigator.pop(context);
              },
            ),
            isAutenticated
                ? SizedBox.shrink()
                : Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person_pin),
                        trailing: Icon(Icons.chevron_right),
                        title: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.group_add),
                        trailing: Icon(Icons.chevron_right),
                        title: Text(
                          'SignIn',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: _buildCardGroups()),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Group>> _buildCardGroups() {
    return FutureBuilder(
      future: groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var groupList = snapshot.data;

          var cards = Column(
              children:
                  groupList.map((group) => GroupCard(group: group)).toList());
          var items = [_buildHeaderWithTextField(), _buildItemsTitle(), cards];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
          );
        } else if (snapshot.hasError) {
          return Column(
            children: <Widget>[Text('${snapshot.error}')],
          );
        }

        return Container(
          padding: EdgeInsets.only(top: 70.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Padding _buildHeaderWithTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(33, 150, 243, 1.0),
        ),
        width: double.infinity,
        height: 180.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Social groups directory',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Icon(
                      FontAwesomeIcons.telegram,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Icon(
                      FontAwesomeIcons.slack,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40.0,
                color: Colors.white,
                width: 410.0,
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      hintText: 'Search',
                      focusColor: Colors.white,
                      hintStyle: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      prefixIcon: Icon(Icons.search),
                      prefixStyle: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      border: InputBorder.none),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 23.0,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildItemsTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Latest groups added',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
      ),
    );
  }
}