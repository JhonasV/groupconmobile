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

  static Future<AlertDialog> emailDialog(
      BuildContext context, Group group) async {
    final size = MediaQuery.of(context).size;
    final action = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          title: Container(
            padding: EdgeInsets.all(15.0),
            height: 50.0,
            width: double.infinity,
            color: Colors.blue,
            child: Text('Send invite link',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          content: Container(
            width: size.width * 1.0,
            height: size.height * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Container(
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
                          onPressed: () => null,
                          // _emailLoaderIndicator ? null : Navigator.of(context).pop(),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
