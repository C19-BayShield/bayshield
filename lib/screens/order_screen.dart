import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/screens/hub_screen.dart';
import 'package:supplyside/screens/profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderScreen extends StatefulWidget {

  OrderScreen({Key key, this.auth, this.userId, this.logoutCallback, this.index}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final int index;

  @override
  State<StatefulWidget> createState() => new _OrderScreenState();

}

class _OrderScreenState extends State<OrderScreen>{
  int _selectedIndex = 0;
  bool _initialized = false;

  List<bool> _isSelected = [true, false, false]; // defaults at Incoming.
  bool _displayIncoming = true;
  bool _displayPending = false;
  bool _displayShipped = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        navigateToHomeScreen(context, widget.userId);
      } else if (index == 2) {
        navigateToProfileScreen(context, widget.userId);
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

  Future navigateToHomeScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HubScreen(userId: userId,
      auth: widget.auth,
    )
    ))
    ;
  }

  Future navigateToProfileScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId,
      auth: widget.auth,
    )
    ))
    ;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index != null && !_initialized) {
      for (int i = 0; i < _isSelected.length; i++) {
        if (i == widget.index) {
          _isSelected[i] = true;
        } else {
          _isSelected[i] = false;
        }
      }
      _initialized = true;
    } else if (widget.index == null) {
      _initialized = true;
    }
    _displayIncoming = _isSelected[0];
    _displayPending = _isSelected[1];
    _displayShipped = _isSelected[2];

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 110,
                        color: Colors.transparent,
                        child: new Text("Orders", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,),
                      ),
                      ToggleButtons(
                        fillColor: Color(0xFFB7CDFF),
                        borderColor: Color(0xFFC4C4C4),
                        selectedBorderColor: Color(0xFFC4C4C4),
                        borderWidth: 2.0,
                        constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 110)/3, minHeight: MediaQuery.of(context).size.height / 25),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          children: <Widget>[
                            new Text("Incoming", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            new Text("Pending", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            new Text("Shipped", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                          ],
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _isSelected.length; i++) {
                              if (i == index) {
                                _isSelected[i] = true;
                              } else {
                                _isSelected[i] = false;
                              }
                            }
                            _displayIncoming = _isSelected[0];
                            _displayPending = _isSelected[1];
                            _displayShipped = _isSelected[2];
                          });
                        },
                        isSelected: _isSelected,
                      ),
                      if (_displayIncoming) new Text("Incoming Orders", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      if (_displayPending) new Text("Pending Orders", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      if (_displayShipped) new Text("Shipped Orders", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                    ],
                  )
              )
          )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onItemTapped),
    );
  }
}