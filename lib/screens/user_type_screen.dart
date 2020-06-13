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

  Column _buildButtonColumn(String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 16),
          child: SizedBox(
          child: new RaisedButton(
            color: Color(0xFF697CC8), 
            elevation: 5.0,
            padding: EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: screenSize.width / 1.7),
                alignment: Alignment.center,
                child: Column( 
                  children: <Widget>[
                    new Text(label,
                      style: new TextStyle(fontSize: 25.0, color: Colors.white,  fontWeight: FontWeight.w400)),
                  ]
                ),
              ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () {
              updateUserType(widget.userId, label);
              Navigator.push(
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
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn('Maker'),
          _buildButtonColumn('Collection Hub'),
          _buildButtonColumn('Medical Organization'),
        ],
      ),
    );

    return Scaffold(
            body: Stack(
              children: <Widget>[
                new FullScreenCover(),
                ListView(
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.height / 6.0,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/images/logo_small.png', height: 100, width: 100),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "I am a...",
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            ),
                          buttonSection,
                        ]
                      ),
                    ),
                  ],
                ),
              ]
            ),
    );
  }
}