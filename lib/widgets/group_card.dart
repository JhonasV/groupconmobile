import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final dynamic showEmailDialog;
  const GroupCard({Key key, this.group, this.showEmailDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.0,
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
              child: Row(
                children: <Widget>[
                  _buildGroupCardButtonLink(
                    FontAwesomeIcons.arrowCircleRight,
                    "Direct Link",
                  ),
                  _buildGroupCardEmailButton(Icons.email, ""),
                  _buildGroupCardButton(FontAwesomeIcons.qrcode, "QR"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    if (await canLaunch(group.url)) {
      await launch(group.url);
    } else {
      throw "Could not lunch ${group.url}";
    }
  }

  Card _buildGroupCardEmailButton(IconData icon, String text) {
    return Card(
      elevation: 3.0,
      color: Colors.green,
      child: FlatButton(
        onPressed: () => showEmailDialog(),
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
}
