import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

class MakerScreen extends StatefulWidget {

  MakerScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MakerScreenState();

}

class _MakerScreenState extends State<MakerScreen>{

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Maker Home"),
        backgroundColor: Color(0xFF313F84),
        actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
      ),
      body: new Container(
        child: new Text("TODO"),
      ),
    );
  }
}