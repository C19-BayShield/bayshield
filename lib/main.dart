import 'package:flutter/material.dart';
import 'package:supplyside/screens/login_screen.dart';
import 'package:supplyside/theme.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/screens/root_screen.dart';
import 'package:in_app_update/in_app_update.dart';

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SupplySide',
      theme: SupplySideTheme,
      routes: {
        LOGIN_SCREEN: (BuildContext context) => LoginSignupScreen(),
      },
      home: new RootScreen(auth: new Auth()));
  }
}
