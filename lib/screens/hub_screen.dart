import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/screens/order_screen.dart';
import 'package:supplyside/screens/profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class HubScreen extends StatefulWidget {

  HubScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HubScreenState();

}

class _HubScreenState extends State<HubScreen>{
  int _selectedIndex = 1;

  // TODO: Replace hard coded values
  int _incoming = 10;
  int _pending = 35;
  int _shipped = 13430;
  String _userType = "C O L L E C T I O N  H U B";
  static String _userName = "Dylan";
  String _greeting = "Hi, " + _userName + ".";
  String _message = "Alert: PPE Design Update. Read More";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        navigateToOrderScreen(context, widget.userId, 0);
      } else if (index == 2) {
        navigateToProfileScreen(context, widget.userId);
      }
    });
  }

  void _onInventoryPressed() {
    setState(() {
      navigateToProfileScreen(context, widget.userId);
    });
  }

  void _onIncomingPressed() {
    setState(() {
      navigateToOrderScreen(context, widget.userId, 0);
    });
  }

  void _onPendingPressed() {
    setState(() {
      navigateToOrderScreen(context, widget.userId, 1);
    });
  }

  void _onShippedPressed() {
    setState(() {
      navigateToOrderScreen(context, widget.userId, 2);
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

  Future navigateToOrderScreen(context, String userId, index) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderScreen(userId: userId,
      auth: widget.auth, index: index,
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
                new UserTypeTag(userTag: _userType),
                new Text(_greeting, style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new AlertTag(message: _message),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: (MediaQuery.of(context).size.width - 120) / 2,
                        color: Colors.transparent,
                        child: new IncomingOrdersCard(incoming: _incoming, onPressed: _onIncomingPressed),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: (MediaQuery.of(context).size.width - 120) / 2,
                        color: Colors.transparent,
                        child: new PendingOrdersCard(pending: _pending, onPressed: _onPendingPressed),
                      ),
                    ]
                  )
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new ShippedOrdersCard(shipped: _shipped, onPressed: _onShippedPressed),
                ),
                new InventoryButton(onPressed: _onInventoryPressed),
              ]
            )
          )
        )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}