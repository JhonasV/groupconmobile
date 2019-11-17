import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';

import 'package:url_launcher/url_launcher.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final dynamic showEmailDialog;
  final String currentUserId;
  final bool areDashboardCards;
  final emailController = TextEditingController();
  GroupCard(
      {Key key,
      this.group,
      this.showEmailDialog,
      this.currentUserId,
      this.areDashboardCards})
      : super(key: key);
  // String _email;
  @override
  Widget build(BuildContext context) {
    bool isGroupOwner = currentUserId == group.user;
    // final authProvider = Provider.of<AuthProvider>(context);
    return Container(
      width: double.infinity,
      height: isGroupOwner && areDashboardCards ? 200.0 : 130.0,
      child: Card(
        elevation: 2.0,
        color: Color.fromRGBO(74, 170, 77, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
              ),
              title: Text(
                group.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 15.0),
                child: _buildCardActions(
                    isGroupOwner, areDashboardCards, context)),
          ],
        ),
      ),
    );
  }

  _buildCardActions(
      bool isGroupOwner, bool areDashboardCards, BuildContext context) {
    if (isGroupOwner && areDashboardCards) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _builActionCardButton(Icons.edit, "Edit", Color(0xFFFF9F12)),
              _builActionCardButton(Icons.delete, "Delete", Color(0xFFE73238)),
            ],
          ),
          Row(
            children: <Widget>[
              _buildGroupCardButtonLink(
                FontAwesomeIcons.arrowCircleRight,
                "Direct Link",
              ),
              _buildGroupCardEmailButton(Icons.email, "", context, group.id),
              _buildGroupCardButton(FontAwesomeIcons.qrcode, "QR"),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildGroupCardButtonLink(
                FontAwesomeIcons.arrowCircleRight,
                "Direct Link",
              ),
              _buildGroupCardEmailButton(Icons.email, "", context, group.id),
              _buildGroupCardButton(FontAwesomeIcons.qrcode, "QR"),
            ],
          )
        ],
      );
    }
  }

  void _launchURL() async {
    if (await canLaunch(group.url)) {
      await launch(group.url);
    } else {
      throw "Could not lunch ${group.url}";
    }
  }

  Card _buildGroupCardEmailButton(
      IconData icon, String text, BuildContext context, String groupId) {
    return Card(
      elevation: 3.0,
      color: Colors.green,
      child: FlatButton(
        onPressed: () => showEmailDialog(context, groupId),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        color: Colors.green,
        textColor: Colors.white,
      ),
    );
  }

  Card _buildGroupCardButton(IconData icon, String text) {
    return Card(
      elevation: 3.0,
      color: Colors.green,
      child: FlatButton(
        onPressed: () => null,
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        color: Colors.green,
        textColor: Colors.white,
      ),
    );
  }

  Card _buildGroupCardButtonLink(IconData icon, String text) {
    return Card(
      elevation: 3.0,
      color: Colors.green,
      child: FlatButton(
        onPressed: () => _launchURL(),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        color: Colors.green,
        textColor: Colors.white,
      ),
    );
  }

  Card _builActionCardButton(IconData icon, String text, Color color) {
    return Card(
      elevation: 3.0,
      color: color,
      child: Container(
        width: 155.0,
        child: FlatButton(
          onPressed: () => null,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Icon(icon),
            SizedBox(width: 3.0),
            Text(text, style: TextStyle(fontWeight: FontWeight.bold))
          ]),
          color: color,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
