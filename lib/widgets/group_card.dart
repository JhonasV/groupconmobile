import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({
    Key key,
    this.group,
  }) : super(key: key);

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
                  _buildGroupCardButton(
                      FontAwesomeIcons.arrowCircleRight, "Direct Link"),
                  _buildGroupCardButton(Icons.email, ""),
                  _buildGroupCardButton(FontAwesomeIcons.qrcode, "QR"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildGroupCardButton(IconData icon, String text) {
    return Card(
      elevation: 3.0,
      color: Colors.green,
      child: FlatButton(
        onPressed: () {},
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
