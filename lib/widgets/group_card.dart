import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/services/EmailService.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

class GroupCard extends StatefulWidget {
  final Group group;
  // final dynamic showEmailDialog;
  // final BuildContext context;
  final String currentUserId;
  final bool areDashboardCards;

  GroupCard({Key key, this.group, this.currentUserId, this.areDashboardCards})
      : super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  final emailController = TextEditingController();

  final _formEmailKey = GlobalKey<FormState>();

  String _emailResponseMessage = '';

  bool _emailLoaderIndicator = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isGroupOwner = widget.currentUserId == widget.group.user;
    return Container(
      width: double.infinity,
      height: isGroupOwner && widget.areDashboardCards ? 200.0 : 140.0,
      child: Card(
        elevation: 2.0,
        color: _getCardBodyColor(widget.group.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: _getCardHeaderColor(widget.group.url),
              child: ListTile(
                leading: _getGroupIcon(widget.group.url),
                title: Text(
                  widget.group.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Container(
              padding: widget.group.private
                  ? EdgeInsets.only(top: 10.0)
                  : EdgeInsets.only(left: 15.0),
              child: widget.group.private
                  ? _buildUnlockedButton(context)
                  : _buildCardActions(
                      isGroupOwner, widget.areDashboardCards, context),
            ),
          ],
        ),
      ),
    );
  }

  _getCardHeaderColor(String url) {
    if (url.contains("whatsapp")) {
      return Color(0xFF4AAA4D);
    } else if (url.contains("slack")) {
      return Color(0xFF3F0F3F);
    } else {
      return Color(0xFF2091EB);
    }
  }

  _getCardBodyColor(String url) {
    if (url.contains("whatsapp")) {
      return Color(0xFF4CAF50);
    } else if (url.contains("telegram")) {
      return Color(0xFF0088cc);
    } else if (url.contains("slack")) {
      return Color(0xFF3F0F3F);
    } else {
      return Colors.blue;
    }
  }

  Widget _getGroupIcon(String url) {
    IconData icon;
    if (url.contains("whatsapp")) {
      icon = FontAwesomeIcons.whatsapp;
    } else if (url.contains("slack")) {
      icon = FontAwesomeIcons.slack;
    } else if (url.contains("telegram")) {
      icon = FontAwesomeIcons.telegram;
    } else if (url.contains("facebook")) {
      icon = FontAwesomeIcons.facebook;
    } else {
      icon = Icons.group;
    }

    return Icon(
      icon,
      color: Colors.white,
    );
  }

  _buildCardActions(
      bool isGroupOwner, bool areDashboardCards, BuildContext context) {
    var creatorButtons = isGroupOwner && areDashboardCards
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                _builActionCardButton(
                  Icons.edit,
                  "Edit",
                  Color(0xFFFF9F12),
                ),
                SizedBox(width: 10.0),
                _builActionCardButton(
                  Icons.delete,
                  "Delete",
                  Color(0xFFE73238),
                ),
              ],
            ),
          )
        : SizedBox.shrink();

    return Column(
      children: <Widget>[
        creatorButtons,
        Row(
          children: <Widget>[
            _buildGroupCardButtonLink(
                FontAwesomeIcons.arrowCircleRight, "Direct Link", context),
            SizedBox(width: 13.0),
            _buildGroupCardEmailButton(
                Icons.email, "", context, widget.group.id),
            SizedBox(width: 13.0),
            _buildGroupCardButton(FontAwesomeIcons.qrcode, "QR", context),
          ],
        ),
      ],
    );
  }

  showEmailDialog(BuildContext context, String groupId) {
    final size = MediaQuery.of(context).size;
    return showDialog(
        barrierDismissible: !_emailLoaderIndicator,
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

  _buildUnlockedButton(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * .8,
              child: RaisedButton(
                onPressed: () {},
                color: _getCardBodyColor(widget.group.url),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.lock,
                      color: Colors.white,
                      size: 18.0,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      "PRIVATE GROUP, UNLOCK IT!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _launchURL() async {
    if (await canLaunch(widget.group.url)) {
      await launch(widget.group.url);
    } else {
      throw "Could not lunch ${widget.group.url}";
    }
  }

  Container _buildGroupCardEmailButton(
      IconData icon, String text, BuildContext context, String groupId) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 10.0),
      width: MediaQuery.of(context).size.width * .2,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () => showEmailDialog(context, groupId),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        color: _getCardBodyColor(widget.group.url),
        textColor: Colors.white,
      ),
    );
  }

  Container _buildGroupCardButton(
      IconData icon, String text, BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 10.0),
      width: MediaQuery.of(context).size.width * .23,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () => showQRDialog(context),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        color: _getCardBodyColor(widget.group.url),
        textColor: Colors.white,
      ),
    );
  }

  Container _buildGroupCardButtonLink(
      IconData icon, String text, BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 10.0),
      width: MediaQuery.of(context).size.width * .40,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () => _launchURL(),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5.0),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        color: _getCardBodyColor(widget.group.url),
        textColor: Colors.white,
      ),
    );
  }

  Container _builActionCardButton(IconData icon, String text, Color color) {
    return Container(
      height: 50.0,
      width: 155.0,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () => null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 10.0),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            )
          ],
        ),
        color: color,
        textColor: Colors.white,
      ),
    );
  }

  Container _buildAlertDialogContent(
      Size size, BuildContext context, String groupId) {
    return Container(
      width: size.width * 1.0,
      height: size.height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailLoaderIndicator
              ? Padding(
                  padding: const EdgeInsets.only(top: 85.0),
                  child: CircularProgressIndicator(),
                )
              : _buildAlertDialogForm(groupId),
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
                onPressed: () {
                  setState(() => _emailLoaderIndicator = true);
                  _sendEmail(groupId, emailController.text.trim());
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
              onPressed: () =>
                  _emailLoaderIndicator ? null : Navigator.of(context).pop(),
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

  void _sendEmail(String groupId, String email) async {
    if (_formEmailKey.currentState.validate()) {
      var emailServiceFuture =
          await EmailService.sendInviteLinkEmail(groupId, email);
      if (emailServiceFuture['statusCode'] == 200) {
        setState(() {
          _emailLoaderIndicator = !_emailLoaderIndicator;
          _emailResponseMessage = emailServiceFuture['body'];
        });
      }
    }
  }

  showQRDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              Container(
                height: 38.0,
                width: 100.0,
                color: Colors.blue,
                child: FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Close",
                    style: TextStyle(fontSize: 21.0, color: Colors.white),
                  ),
                ),
              ),
            ],
            title: Container(
              padding: EdgeInsets.all(15.0),
              height: 55.0,
              color: Colors.blue,
              child: Text(
                "${widget.group.name} group QR",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Container(
              height: 280.0,
              width: 200.0,
              child: Center(
                child: QrImage(
                  data: widget.group.url,
                  version: QrVersions.auto,
                  size: 400.0,
                ),
              ),
            ),
          );
        });
  }
}
