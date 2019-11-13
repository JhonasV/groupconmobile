import 'package:flutter/material.dart';
import 'package:groupcon01/services/EmailService.dart';

class EmailForm extends StatefulWidget {
  final String groupId;

  EmailForm({this.groupId});

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final emailController = TextEditingController();

  _sendEmail() async {
    var response = await EmailService.sendInviteLinkEmail(
        widget.groupId, emailController.text.trim());
    var body = response['body'];
    int statusCode = response['statusCode'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // child: showEmailDialog(),
        );
  }
}
