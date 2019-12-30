import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/screens/dashboard_screen.dart';
import 'package:groupcon01/services/GroupService.dart';

class CreateScreen extends StatefulWidget {
  static final String id = 'create_screen';
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var _formKey = GlobalKey<FormState>();
  String _name, _url;
  bool _isLoading = false;
  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = !_isLoading);
      _formKey.currentState.save();
      await GroupService.create(Group(name: _name, url: _url));
      Navigator.of(context).pushNamedAndRemoveUntil(
          DashboardScreen.id, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create'),
          ),
          body: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        _isLoading
                            ? LinearProgressIndicator()
                            : SizedBox.shrink(),
                        SizedBox(height: 30.0),
                        Text(
                          'Create a new group',
                          style: TextStyle(fontSize: 25.0, color: Colors.blue),
                        ),
                        SizedBox(height: 40.0),
                        _buildFormElements(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFormElements() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (input) => _name = input.trim(),
              decoration: InputDecoration(hintText: 'Name'),
              validator: (input) =>
                  input.length < 5 ? 'Enter a min of 5 characters' : null,
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (input) => _url = input.trim(),
              decoration: InputDecoration(hintText: 'URL'),
              validator: (input) =>
                  input.length < 10 ? 'Enter a valid URL' : null,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 35.0,
            width: double.infinity,
            child: FlatButton(
              child: Text(
                'SUBMIT',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onPressed: () => _isLoading ? null : _submit(),
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
