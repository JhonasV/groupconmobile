import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupcon01/models/user.dart';
import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/screens/login_screen.dart';
import 'package:groupcon01/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  SharedPreferences sharedPreferences;
  var _formKey = GlobalKey<FormState>();
  String _email, _password, _confirmPassword, _nickName;
  bool isLoading = false;

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      // setState(() {
      //   _isLoading = !_isLoading;
      // });
      // _formKey.currentState.save();
      // print(_email);
      // print(_password);
      // print(_confirmPassword);
      // print(_nickName);

      // //TODO: Save data
      // //Call service here...
      // User newUser = User(email: _email, nickname: _nickName);
      // Map<String, dynamic> response =
      //     await AuthService.register(newUser, _password);
      // dynamic jsonData;
      // var body = response['body'];
      // jsonData = json.decode(body);
      // if (response['statusCode'] == 200) {
      //   // OK...
      //   sharedPreferences = await SharedPreferences.getInstance();

      //   String token = jsonData['token'];
      //   String currentUserId = jsonData['userId'];

      //   sharedPreferences.setString('token', token);
      //   sharedPreferences.setString('currentUserId', currentUserId);
      //   // AuthService.currentUser();
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => HomeScreen()),
      //       (Route<dynamic> route) => false);
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 27.0,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  width: double.infinity,
                  height: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 55.0),
                          Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 27.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(height: 10.0),
                          _buildTextFormFieldEmail(),
                          SizedBox(height: 15.0),
                          _buildTextFormFieldNickName(),
                          SizedBox(height: 15.0),
                          _buildTextFormFieldPassword(),
                          SizedBox(height: 15.0),
                          _buildTextFormFieldPasswordConf(),
                          SizedBox(height: 15.0),
                          _buildSubmitButton(),
                          Text(
                            "or",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.blue),
                          ),
                          SizedBox(height: 10.0),
                          _buildSignInButton(context)
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  Container _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: Colors.blue,
        child: Text(
          'Submit',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19.0),
        ),
        onPressed: () => _onSubmit(),
      ),
    );
  }

  TextFormField _buildTextFormFieldEmail() {
    return TextFormField(
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
        style: TextStyle(fontSize: 18.0),
        onSaved: (value) => _email = value,
        validator: (val) => !val.contains('@') ? 'Enter a valid email' : null);
  }

  TextFormField _buildTextFormFieldNickName() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'NickName',
        prefixIcon: Icon(FontAwesomeIcons.userAlt),
      ),
      style: TextStyle(fontSize: 18.0),
      onSaved: (value) => _nickName = value,
      validator: (val) => val.length < 5 ? 'Enter atleast 5 characters' : null,
    );
  }

  TextFormField _buildTextFormFieldPassword() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(FontAwesomeIcons.lock),
      ),
      style: TextStyle(fontSize: 18.0),
      obscureText: true,
      onSaved: (value) => _password = value,
      validator: (val) => val.length < 5 ? 'Enter atleast 5 characters' : null,
    );
  }

  TextFormField _buildTextFormFieldPasswordConf() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password confirmation',
        prefixIcon: Icon(FontAwesomeIcons.lock),
      ),
      style: TextStyle(fontSize: 18.0),
      obscureText: true,
      onSaved: (value) => _confirmPassword = value,
      validator: (val) => val.length < 5 ? 'Enter atleast 5 characters' : null,
    );
  }

  FlatButton _buildSignInButton(BuildContext context) {
    return FlatButton(
      child: Text(
        "Log In",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      color: Colors.blue,
      onPressed: () {
        Navigator.of(context).pushNamed(LoginScreen.id);
      },
    );
  }
}
