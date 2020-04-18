import 'package:flutter/material.dart';
import 'package:supplyside/screens/signup_screen.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';

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

    Widget promptSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Sign Up as a...',
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

  Column _buildButtonColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Color(0xFFE6B819), size: 32.0,),
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 32),
          child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color(0xFF313F84),
            child: new Text(label,
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
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

    return new Scaffold(
      appBar: new AppBar(
          title: new Text('BayShield Signup'),
          backgroundColor: Color(0xFF313F84),
        ),
      body: ListView(
        children: [promptSection, buttonSection],
      ),
    );
  }
}