import 'package:flutter/material.dart';
import 'package:groupcon01/services/EmailService.dart';

class SendEmailScreen extends StatefulWidget {
  static final String id = 'send_email_screen';
  final String groupId;
  SendEmailScreen({this.groupId});

  @override
  _SendEmailScreenState createState() => _SendEmailScreenState(groupId);
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  final emailController = TextEditingController();
  _SendEmailScreenState(this.groupId);
  final String groupId;
  final _formEmailKey = GlobalKey<FormState>();

  String _emailResponseMessage = '';

  bool _emailLoaderIndicator = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Send Email"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: size.height * .03),
          padding: EdgeInsets.all(10.0),
          child: Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: Text(
                        'Send your link',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Form(
                  key: _formEmailKey,
                  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) => !input.trim().contains('@')
                              ? 'Enter a valid email'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: 'Email', prefixIcon: Icon(Icons.mail)),
                        ),
                        SizedBox(height: 20.0),
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
                )
              ],
            ),
          ),
        ),
      ),
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
}
