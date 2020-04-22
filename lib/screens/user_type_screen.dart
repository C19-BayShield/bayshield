import 'package:flutter/material.dart';
import 'package:supplyside/screens/signup_screen.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';

class UserTypeScreen extends StatefulWidget {
  UserTypeScreen({this.userId, this.auth});

  final BaseAuth auth;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _UserTypeScreenState();

}

class _UserTypeScreenState extends State<UserTypeScreen>{
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();

  Future updateUserType(String userId, String type) async {
    try {
      await _firestoreUsers.updateUserType(userId, type);
    } catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Widget promptSection = Container(
      padding: const EdgeInsets.only(top: 94.0),
      child: Text(
        'Sign Up as a...',
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

  Column _buildButtonColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 32, bottom: 32),
          child: SizedBox(
          height: screenSize.height / 7.7,
          child: new RaisedButton(
            elevation: 5.0,
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xD68134), Color(0xF5B819), Color(0xFFE6B819)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Container(
                padding: EdgeInsets.only(top: 12),
                constraints: BoxConstraints(maxWidth: screenSize.width / 1.7, minHeight: 70.0),
                alignment: Alignment.center,
                child: Column( 
                  children: <Widget>[
                    Icon(icon, color: Colors.white, size: 28.0),
                    new SizedBox(height: 6),
                    new Text(label,
                      style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                  ]
                ),
              ),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () {
              updateUserType(widget.userId, label);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen(userId: widget.userId, auth: widget.auth, label: label)),
              );
            }
          ),
        ))
      ],
    );
  }

    Widget buttonSection = Container(
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Icons.local_hospital, 'Medical Facility'),
          _buildButtonColumn(Icons.share, 'Collection Hub'),
          _buildButtonColumn(Icons.lightbulb_outline, 'Maker'),
        ],
      ),
    );

    return Scaffold(
            body: Stack(
              children: <Widget>[
                new FullScreenCover(),
                ListView(
                  children: [promptSection, buttonSection],
                ),
                  new BayShieldAppBar(title: 'C19 | BayShield')
              ]
            ),
    );
  }
}