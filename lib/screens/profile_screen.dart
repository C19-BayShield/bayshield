import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/screens/hub_screen.dart';
import 'package:supplyside/screens/order_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen>{
  int _selectedIndex = 2;

  List<bool> _isSelected = [true, false]; // defaults at Inventory.
  bool _displayInventory = true;
  bool _displaySettings = false;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
          child: new Container(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 110,
                        color: Colors.transparent,
                        child: new Padding(
                          child: new Text("Dylan's Profile", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,),
                          padding: EdgeInsets.only(top: 30, bottom: 25)
                        )
                      ),
                      ToggleButtons(
                        fillColor: Color(0xFFB7CDFF),
                        borderColor: Color(0xFFB2B2B2),
                        selectedBorderColor: Color(0xFFB2B2B2),
                        borderWidth: 2.0,
                        constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 110)/2, minHeight: MediaQuery.of(context).size.height / 25),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        children: <Widget>[
                          new Text("Inventory", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,),
                          new Text("Settings", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            _isSelected[index] = true;
                            _isSelected[1 - index] = false;
                            _displayInventory = _isSelected[0];
                            _displaySettings = _isSelected[1];
                          });
                        },
                        isSelected: _isSelected,
                      ),
                      if (_displayInventory) new Text("Inventory", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      if (_displaySettings) new Text("Settings", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                    ]
                  )
              )
          )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}