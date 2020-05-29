import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
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
  int _selectedIndex = 1; // default loads Home Page.

  // TODO: Replace hard coded values
  int _incoming = 10;
  int _pending = 35;
  int _shipped = 13430;
  String _userType = "C O L L E C T I O N  H U B";
  static String _userName = "Dylan";
  String _greeting = "Hi, " + _userName + ".";
  String _message = "Alert: PPE Design Update. Read More";

  int _index = 0;

  bool _initialized = false;

  List<bool> _isSelectedOrdersPage = [true, false, false]; // defaults at Incoming tab.
  bool _displayIncoming = true;
  bool _displayPending = false;
  bool _displayShipped = false;

  List<bool> _isSelectedProfilePage = [true, false]; // defaults at Inventory tab.
  bool _displayInventory = true;
  bool _displaySettings = false;

  void _onNavigationIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
      build(context);
    });
  }

  void _onInventoryPressed() {
    _selectedIndex = 2;
    build(context);
  }

  void _onIncomingPressed() {
    _selectedIndex = 0;
    _index = 0;
    _initialized = false;
    build(context);
  }

  void _onPendingPressed() {
    _selectedIndex = 0;
    _index = 1;
    _initialized = false;
    build(context);
  }

  void _onShippedPressed() {
    _selectedIndex = 0;
    _index = 2;
    _initialized = false;
    build(context);
  }

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget buildHomePage() {
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
                        child: new IncomingItemsCard(incoming: _incoming, onPressed: _onIncomingPressed),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: (MediaQuery.of(context).size.width - 120) / 2,
                        color: Colors.transparent,
                        child: new PendingItemsCard(pending: _pending, onPressed: _onPendingPressed),
                      ),
                    ]
                  )
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new ShippedItemsCard(shipped: _shipped, onPressed: _onShippedPressed),
                ),
                new InventoryButton(onPressed: _onInventoryPressed),
              ]
            )
          )
        )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildOrdersPage() {
    if (!_initialized) {
      for (int i = 0; i < _isSelectedOrdersPage.length; i++) {
        if (i == _index) {
          _isSelectedOrdersPage[i] = true;
        } else {
          _isSelectedOrdersPage[i] = false;
        }
      }
      _initialized = true;
    }

    _displayIncoming = _isSelectedOrdersPage[0];
    _displayPending = _isSelectedOrdersPage[1];
    _displayShipped = _isSelectedOrdersPage[2];

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
                    child: new Text("Orders", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,),
                    padding: EdgeInsets.only(top: 30, bottom: 25)
                  )
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
                      for (int i = 0; i < _isSelectedOrdersPage.length; i++) {
                        if (i == index) {
                          _isSelectedOrdersPage[i] = true;
                        } else {
                          _isSelectedOrdersPage[i] = false;
                        }
                      }
                      _displayIncoming = _isSelectedOrdersPage[0];
                      _displayPending = _isSelectedOrdersPage[1];
                      _displayShipped = _isSelectedOrdersPage[2];
                    });
                  },
                  isSelected: _isSelectedOrdersPage,
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
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildProfilePage() {
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
                      _isSelectedProfilePage[index] = true;
                      _isSelectedProfilePage[1 - index] = false;
                      _displayInventory = _isSelectedProfilePage[0];
                      _displaySettings = _isSelectedProfilePage[1];
                    });
                  },
                  isSelected: _isSelectedProfilePage,
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
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0) {
      return buildOrdersPage();
    } else if (_selectedIndex == 1) {
      return buildHomePage();
    } else if (_selectedIndex == 2) {
      return buildProfilePage();
    }
  }
}