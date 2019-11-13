import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/services/EmailService.dart';
import 'package:groupcon01/widgets/email_form.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupCard extends StatelessWidget {
  static final Group group;
  var emailController = TextEditingController();
  GroupCard({Key key, this.group}) : super(key: key);
  // String _email;
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
        onPressed: () => EmailForm(),
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

  showEmailDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            title: _buildAlertDialogTitle(),
            content: _buildAlertDialogContent(size, context),
          );
        });
  }

  Container _buildAlertDialogContent(Size size, BuildContext context) {
    return Container(
      width: size.width * 1.0,
      height: size.height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAlertDialogForm(),
          Spacer(),
          _buildAlertDialogCustomFooter(context),
        ],
      ),
    );
  }

  Padding _buildAlertDialogForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
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
                onPressed: () async {
                  var email = emailController.text.trim();

                  var response =
                      await EmailService.sendInviteLinkEmail(group.id, email);
                  var body = response['body'];
                  int statusCode = response['statusCode'];
                },
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
