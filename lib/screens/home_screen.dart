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
  final _formEmailKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final searchController = TextEditingController();
  SharedPreferences sharedPreferences;
  bool _isLoading = true;
  String _emailResponseMessage = '';
  List<Group> auxGroups = [];
  List<Group> groupList = [];
  String currentUserId;
  @override
  void initState() {
    // groups = GroupService.fetchLatestsGroups();
    GroupService.fetchLatestsGroups().then((value) {
      setState(() {
        auxGroups.addAll(value);
        groupList = auxGroups;
        _isLoading = !_isLoading;
      });
    });
    _setupCurrentId();
    super.initState();
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

  void _sendEmail(String groupId, String email) {
    if (_formEmailKey.currentState.validate()) {
      setState(() => _isLoading = true);
      Future<dynamic> emailServiceFuture =
          EmailService.sendInviteLinkEmail(groupId, email);
      FutureBuilder(
        future: emailServiceFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['statusCode'] == 200) {
              setState(() {
                _isLoading = false;
                _emailResponseMessage = "Email sended succesfully!";
              });
            }
          }
        },
      );
    }
  }

  _setupItems(String currentUserId) {
    var groups = Column(
      children: groupList
          .map((group) => GroupCard(
                group: group,
                showEmailDialog: showEmailDialog,
                currentUserId: currentUserId,
                areDashboardCards: false,
              ))
          .toList(),
    );
    var screenItems = [_buildHeaderWithTextField(), _buildItemsTitle(), groups];
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
                        groupList = groupList
                            .where((group) =>
                                group.name.toLowerCase().contains(value))
                            .toList();
                      });
                    } else {
                      setState(() {
                        groupList = auxGroups;
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
            ? "Search results: ${groupList.length}"
            : 'Latest groups added',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
      ),
    );
  }

  showEmailDialog(BuildContext context, String groupId) {
    final size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            title: _buildAlertDialogTitle(),
            content: _buildAlertDialogContent(size, context, groupId),
          );
        });
  }

  Container _buildAlertDialogContent(
      Size size, BuildContext context, String groupId) {
    return Container(
      width: size.width * 1.0,
      height: size.height * 0.4,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildAlertDialogForm(groupId),
                Spacer(),
                _buildAlertDialogCustomFooter(context),
              ],
            ),
    );
  }

  Padding _buildAlertDialogForm(String groupId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      child: Form(
        key: _formEmailKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              validator: (input) =>
                  !input.trim().contains('@') ? 'Enter a valid email' : null,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email', prefixIcon: Icon(Icons.mail)),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              height: 35.0,
              child: FlatButton(
                onPressed: () =>
                    _sendEmail(groupId, emailController.text.trim()),
                child: Text(
                  'Send',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20.0),
            _emailResponseMessage.length > 0
                ? Text(
                    _emailResponseMessage,
                    style: TextStyle(fontSize: 20.0),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Container _buildAlertDialogCustomFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: Colors.blue,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 120.0,
            height: 30.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            padding: EdgeInsets.only(right: 10.0),
            child: FlatButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildAlertDialogTitle() {
    return Container(
      padding: EdgeInsets.all(15.0),
      height: 50.0,
      width: double.infinity,
      color: Colors.blue,
      child: Text('Send invite link',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
