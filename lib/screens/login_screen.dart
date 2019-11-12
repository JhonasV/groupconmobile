import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/screens/home_screen.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _key = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;
  void _submitForm() async {
    if (_key.currentState.validate()) {
      setState(() => isLoading = true);
      //TODO: AuthService.Login(_email, _password);
      var response = await http.post('http://10.0.2.2:5000/api/v1/auth/login',
          body: {'email': _email.text, 'password': _password.text});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        String token = jsonData['token'];
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', token);
        setState(() {
          isLoading = false;

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        });
      } else {
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: <Widget>[
                        SafeArea(
                          child: Container(
                            alignment: Alignment.topLeft,
                            height: 30.0,
                            width: double.infinity,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 27.0,
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 80.0),
                              child: Text(
                                'GroupCon',
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 80.0),
                              child: Icon(
                                FontAwesomeIcons.connectdevelop,
                                size: 35.0,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox.shrink(),
                        SizedBox(height: 50.0),
                        _buildEmailTextField(),
                        SizedBox(height: 30.0),
                        _buildPasswordTextField(),
                        SizedBox(height: 30.0),
                        _buildFormFlatButton(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildFormFlatButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        height: 40.0,
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          onPressed: () => _submitForm(),
        ),
      ),
    );
  }

  Container _buildPasswordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        validator: (input) =>
            input.trim().length < 5 ? 'The min characters is 5' : null,
        controller: _password,
        decoration: InputDecoration(hintText: 'Password'),
        obscureText: true,
      ),
    );
  }

  Container _buildEmailTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: 'Email'),
        controller: _email,
        validator: (input) =>
            !input.trim().contains('@') ? 'Enter a valid email' : null,
      ),
    );
  }
}
