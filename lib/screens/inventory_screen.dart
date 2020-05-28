import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/screens/hub_screen.dart';
import 'package:supplyside/screens/order_screen.dart';
import 'package:supplyside/screens/settings_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class InventoryScreen extends StatefulWidget {

  InventoryScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _InventoryScreenState();

}

class _InventoryScreenState extends State<InventoryScreen>{
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        navigateToOrderScreen(context, widget.userId);
      } else if (index == 1) {
        navigateToHomeScreen(context, widget.userId);
      }
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Future navigateToOrderScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderScreen(userId: userId,
      auth: widget.auth,
    )
    ))
    ;
  }

  Future navigateToHomeScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HubScreen(userId: userId,
      auth: widget.auth,
    )
    ))
    ;
  }

  Future navigateToSettingsScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen(userId: userId,
      auth: widget.auth,
    )
    ))
    ;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
          child: new Container(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          color: Colors.transparent,
                          child: new Text("Inventory", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,),
                        ),
                      ]
                  )
              )
          )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}