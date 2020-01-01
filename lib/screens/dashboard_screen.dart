import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/screens/create_screen.dart';
import 'package:groupcon01/services/GroupService.dart';
import 'package:groupcon01/widgets/drawer.dart';
import 'package:groupcon01/widgets/group_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static final String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Group> userGroups = [];
  bool _isLoading = true;
  bool noGroupsAdded = false;
  SharedPreferences sharedPreferences;
  String currentUserId;
  @override
  void initState() {
    _setupFetchUserGroups();
    _setupCurrentId();
    super.initState();
  }

  _setupFetchUserGroups() async {
    List<Group> groups = await GroupService.userGroups();
    setState(() {
      userGroups = groups;
      noGroupsAdded = userGroups.length > 0;
      _isLoading = !_isLoading;
    });
  }

  _setupCurrentId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = sharedPreferences.getString('currentUserId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateScreen(
                      group: null,
                    ),
                  ),
                );
              },
              iconSize: 25.0,
            )
          ],
        ),
        body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: _builGroupCards(),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _builGroupCards() {
    List<dynamic> items = [_buildHeader()];
    if (userGroups.length > 0) {
      var groupCards = Column(
        children: userGroups
            .map((group) => GroupCard(
                  group: group,
                  areDashboardCards: true,
                  currentUserId: currentUserId,
                ))
            .toList(),
      );
      items.add(groupCards);
    } else {
      var noGroupsAdded = Card(
        child: Container(
          padding: EdgeInsets.only(top: 15.0),
          height: 60.0,
          width: double.infinity,
          child: Text(
            'No groups added yet!',
            style: TextStyle(fontSize: 25.0, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
      );
      items.add(noGroupsAdded);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
        // return Container();
      },
    );
  }

  Container _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 25.0),
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.blue),
      child: Text(
        'Your groups!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
