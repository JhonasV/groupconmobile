import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> confirmDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(
                DialogAction.abort,
              ),
              child: Text('No'),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(
                DialogAction.yes,
              ),
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    return (action != null) ? action : DialogAction.abort;
  }

  static Future<DialogAction> unlockGroupAlert(
      BuildContext context, bool isLoading) async {
    Size size = MediaQuery.of(context).size;
    final action = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              width: size.width * 1,
              height: size.height * .09,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: size.width * .2,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.abort),
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            )
          ],
          titlePadding: EdgeInsets.zero,
          title: Container(
            height: size.height * .08,
            padding: EdgeInsets.all(15.0),
            color: Colors.blue,
            child: Text(
              'Unlock the group',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          content: Container(
            height: size.height * .2,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Group Password...',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 35.0,
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'Unlock',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
    return action;
  }
}
