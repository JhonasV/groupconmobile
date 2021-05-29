import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';
import 'package:groupcon01/screens/dashboard_screen.dart';
import 'package:groupcon01/services/GroupService.dart';
import 'package:groupcon01/widgets/dialogs.dart';

class CreateScreen extends StatefulWidget {
  static final String id = 'create_screen';
  final Group group;
  CreateScreen({this.group});
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var _formKey = GlobalKey<FormState>();
  String _name, _url, _password, _confirmPassword, _message = '';
  bool _isLoading = false;

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = !_isLoading);
      _formKey.currentState.save();
      await GroupService.create(
          Group(name: _name, url: _url, password: _password));
      Navigator.of(context).pushNamedAndRemoveUntil(
          DashboardScreen.id, (Route<dynamic> route) => false);
    }
  }

  _update() async {
    if (_formKey.currentState.validate()) {
      final action = await Dialogs.confirmDialog(
          context, 'Warning', 'Are you sure to update this group?');
      if (action == DialogAction.yes) {
        setState(() => _isLoading = !_isLoading);
        _formKey.currentState.save();
        var response = await GroupService.updateGroup(
            Group(name: _name, url: _url, id: widget.group.id), '');
        if (response['updated'] == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              DashboardScreen.id, (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = !_isLoading;
            _message = response['error'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _name = widget.group.name;
      _url = widget.group.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdating = widget.group != null;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(isUpdating ? 'Update' : 'Create'),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
                SizedBox(height: 25.0),
                _buildTitleText(isUpdating),
                SizedBox(height: 10.0),
                _message != '' ? _buildMessageText() : SizedBox.shrink(),
                SizedBox(height: 30.0),
                _buildNameTextFormField(),
                SizedBox(height: 10.0),
                _buildUrlTextFormField(),
                SizedBox(height: 10.0),
                _buildPasswordTextFormField(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (input) => _confirmPassword = input.trim(),
                    decoration: InputDecoration(hintText: 'Confirm password'),
                    obscureText: true,
                    validator: (input) =>
                        _password != input ? 'Password no match' : null,
                  ),
                ),
                _buildFlatButton(isUpdating),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitleText(bool isUpdating) {
    return Text(
      isUpdating ? 'Update the group information' : 'Create a new group',
      style: TextStyle(fontSize: 25.0, color: Colors.blue),
    );
  }

  Text _buildMessageText() {
    return Text(
      _message,
      style: TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22.0),
    );
  }

  Padding _buildNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onSaved: (input) => _name = input.trim(),
        initialValue: _name,
        decoration: InputDecoration(hintText: 'Name'),
        validator: (input) =>
            input.length < 5 ? 'Enter a min of 5 characters' : null,
      ),
    );
  }

  Padding _buildUrlTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: _url,
        onSaved: (input) => _url = input.trim(),
        decoration: InputDecoration(hintText: 'URL'),
        validator: (input) => input.length < 10 ? 'Enter a valid URL' : null,
      ),
    );
  }

  Padding _buildPasswordTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onSaved: (input) => _password = input.trim(),
        onChanged: (input) => _password = input.trim(),
        decoration: InputDecoration(hintText: 'Password'),
        obscureText: true,
        validator: (input) =>
            input.length < 5 ? 'The password must have 5 characters min' : null,
      ),
    );
  }

  _buildFlatButton(bool isUpdating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 35.0,
      width: double.infinity,
      child: FlatButton(
        child: Text(
          isUpdating ? 'UPDATE' : 'SUBMIT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _isLoading ? null : isUpdating ? _update() : _submit(),
        color: Colors.blue,
      ),
    );
  }
}
