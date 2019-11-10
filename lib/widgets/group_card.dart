import 'package:flutter/material.dart';
import 'package:groupcon01/models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({
    Key key,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.0,
      child: Card(
        color: Color.fromRGBO(74, 170, 77, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.file_upload,
                color: Colors.white,
              ),
              title: Text(
                group.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text('Direct Link'),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () {},
                    child: Icon(Icons.mail),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () {},
                    child: Icon(Icons.code),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
