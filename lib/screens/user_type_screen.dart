import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/screens/root_screen.dart';

class UserTypeScreen extends StatefulWidget {
  UserTypeScreen({this.userId, this.auth, this.loginCallback});

  final BaseAuth auth;
  final String userId;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _UserTypeScreenState();

}

class _UserTypeScreenState extends State<UserTypeScreen>{

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
              widget.loginCallback();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RootScreen(auth: widget.auth)),
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