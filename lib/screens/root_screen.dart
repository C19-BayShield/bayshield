import 'package:flutter/material.dart';
import 'package:supplyside/screens/login_screen.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/screens/consumer_screen.dart';
import 'package:supplyside/screens/maker_screen.dart';
import 'package:supplyside/screens/hub_screen.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/locator.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootScreen extends StatefulWidget {
  RootScreen({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  User user;
  String _userType = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      user = null;
      _userType = '';
    });
  }

  Future _getUserType(String id) async {
    try {
      User temp = await _firestoreUsers.getUser(_userId);
      if (temp != null) {
        setState(() {
          user = temp;
          _userType = temp.getType();
        });
      }     
    } catch (e) {
      return e.message;
    }      
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN: 
         _getUserType(_userId);
        if (_userId.length > 0 && _userId != null) {
          switch(_userType) { 
              case 'Medical Facility': { 
                return new ConsumerScreen(
                  userId: _userId,
                  auth: widget.auth,
                  logoutCallback: logoutCallback,
                );
              } 
              break; 
              case 'Maker': { 
                return new MakerScreen(
                userId: _userId,
                auth: widget.auth,
                logoutCallback: logoutCallback,
                );
              } 
              break; 
              case 'Collection Hub': { 
                return new HubScreen(
                userId: _userId,
                auth: widget.auth,
                logoutCallback: logoutCallback,
                );
              } 
              break;      
              default: { 
                return buildWaitingScreen();
              }
              break; 
            } 
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}