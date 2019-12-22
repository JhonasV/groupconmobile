import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/screens/dashboard_screen.dart';
import 'package:groupcon01/services/EmailService.dart';
import 'package:groupcon01/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/services/GroupService.dart';
import 'package:groupcon01/widgets/group_card.dart';

class HomeScreen extends StatefulWidget {
  static final String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<List<Group>> groups;

  final searchController = TextEditingController();
  SharedPreferences sharedPreferences;
  bool _isLoading = true;

  List<Group> auxLatestGroups = [];

  List<Group> groups = [];
  List<Group> latestGroups = [];

  String currentUserId;
  @override
  void initState() {
    super.initState();
    _setupFetchLatestsGroups();
    _setupCurrentUserId();
  }

  _setupFetchLatestsGroups() async {
    var groupMap = await GroupService.fetchLatestsGroups();
    setState(() {
      groups = groupMap['groups'];
      latestGroups = groupMap['latestGroups'];
      auxLatestGroups = latestGroups;
      _isLoading = !_isLoading;
    });
  }

  _setupCurrentUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = sharedPreferences.getString('currentUserId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('GroupCon'),
          backgroundColor: Colors.blue,
        ),
        drawer: DrawerWidget(),
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
                // Expanded(child: _buildCardGroups()),

                Expanded(child: _setupItems(currentUserId)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setupItems(String currentUserId) {
    var latest = Column(
      children: latestGroups
          .map((group) => GroupCard(
                group: group,
                // showEmailDialog: showEmailDialog,
                currentUserId: currentUserId,
                areDashboardCards: false,
              ))
          .toList(),
    );
    var screenItems = [_buildHeaderWithTextField(), _buildItemsTitle(), latest];
    return _buildItems(screenItems);
  }

  Widget _buildItems(List<RenderObjectWidget> screenItems) {
    if (_isLoading) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
        itemCount: screenItems.length,
        itemBuilder: (context, index) {
          return screenItems[index];
        },
      );
    }
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
                child: TextField(
                  controller: searchController,
                  onChanged: (input) {
                    var value = input.toLowerCase();
                    if (value.length > 0) {
                      print(value);
                      setState(() {
                        latestGroups = groups
                            .where((group) =>
                                group.name.toLowerCase().contains(value))
                            .toList();
                      });
                    } else {
                      setState(() {
                        latestGroups = auxLatestGroups;
                      });
                    }
                  },
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
                      fontSize: 23.0),
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
        searchController.text.length > 0
            ? "Search results: ${latestGroups.length}"
            : 'Latest groups added',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
      ),
    );
  }
}
