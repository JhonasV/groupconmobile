import 'package:flutter/material.dart';
import 'package:groupcon01/screens/home_screen.dart';
import 'package:groupcon01/services/AuthService.dart';
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
      print(_email.text);
      print(_password.text);
      isLoading = true;
      //TODO: AuthService.Login(_email, _password);
      var token = AuthService.login(_email.text, _password.text);
      if (token != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        // sharedPreferences.setString('token', token);
        FutureBuilder(
          future: token,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              setState(() {
                isLoading = false;
                sharedPreferences.setString('token', snapshot.data);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
              });
            }
          },
        );
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
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 130.0),
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
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            _submitForm();
          },
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
