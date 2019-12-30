import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:groupcon01/screens/register_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/services/AuthService.dart';

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
  String _loginError = '';
  void _submitForm() async {
    if (_key.currentState.validate()) {
      setState(() => isLoading = true);

      //Make http request to login
      Map<String, dynamic> response =
          await AuthService.login(_email.text.trim(), _password.text.trim());
      int statusCode = response['statusCode'];
      var body = response['body'];

      dynamic jsonData;
      //Verify if is ok, save the token and redirect to home page
      if (statusCode == 200) {
        jsonData = json.decode(body);
        String token = jsonData['token'];
        // String currentUserId = jsonData['current']('id');

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', token);
        AuthService.currentUser();
        // sharedPreferences.setString('currentUserId', currentUserId);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);

        //Verify input errors
      } else if (statusCode == 400) {
        jsonData = json.decode(body);
        String error = jsonData['error'];

        setState(() {
          _loginError = error;
          isLoading = false;
        });
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
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Form(
            key: _key,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SafeArea(
                          child: _buildAppbarNavigator(context),
                        ),
                        _buildLoginTitle(),
                        SizedBox(height: 10.0),
                        _loginError != ''
                            ? _buildLoginErrorMessage()
                            : SizedBox.shrink(),
                        SizedBox(height: 50.0),
                        _buildEmailTextField(),
                        SizedBox(height: 30.0),
                        _buildPasswordTextField(),
                        SizedBox(height: 30.0),
                        _buildFormFlatButton(),
                        SizedBox(height: 10.0),
                        Text(
                          "or",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.blue),
                        ),
                        SizedBox(height: 10.0),
                        _buildSignInButton(context),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  FlatButton _buildSignInButton(BuildContext context) {
    return FlatButton(
      child: Text(
        "Sign Up",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      color: Colors.blue,
      onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.id),
    );
  }

  Row _buildLoginTitle() {
    return Row(
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
      ],
    );
  }

  Container _buildAppbarNavigator(BuildContext context) {
    return Container(
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
    );
  }

  Container _buildLoginErrorMessage() {
    return Container(
      width: 300.0,
      height: 40.0,
      color: Colors.redAccent[50],
      child: Text(
        _loginError,
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22.0),
      ),
    );
  }

  Padding _buildFormFlatButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
