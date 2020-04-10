import 'package:flutter/material.dart';

final ThemeData SupplySideTheme = new ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Color(0xFFF4BA5B),
    backgroundColor: Color(0xFFEDEDEF),
    buttonColor: Color(0xFF7364FF),
    primaryIconTheme: IconThemeData(color: Color(0xFF209E9E), size: 24, opacity: 1.0),
    iconTheme: IconThemeData(color: Color(0xFF209E9E), size: 24, opacity: 1.0),
    accentIconTheme: IconThemeData(color: Color(0xFF209E9E), size: 24, opacity: 1.0),



    // Define the default font family.
    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: new TextTheme(
      headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
      caption: TextStyle(fontSize: 12.0,letterSpacing: 1.25, color: Colors.white),
      subtitle1: TextStyle(fontSize: 18.0,letterSpacing: .15, color: Colors.white, fontWeight: FontWeight.normal),
      subtitle2: TextStyle(fontSize: 14.0,letterSpacing: .1, color: Colors.white),
      bodyText1: TextStyle(fontSize: 16.0,letterSpacing: .5, color: Colors.white),
      bodyText2: TextStyle(fontSize: 14.0,letterSpacing: .25, color: Colors.white),
      button: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, color: Colors.white),
    ),
  );