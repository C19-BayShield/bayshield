import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
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
  int _distributed = 13430;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: new AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF313F84),
          title: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Image.asset('assets/images/logo.png', color: Colors.white, height: 60),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: new Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 25.0,
                  width: 200.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFd48032).withOpacity(0.25),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: new Center(
                      child: new Text("C O L L E C T I O N  H U B",
                        style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                    )
                  ),
                ),
                new Text("Hi, Dylan.", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                Container(
                  height: 40.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF676E8B),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: new Center(
                        child: new Row (
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.warning),
                            ),
                            new Text(" Alert: PPE Design Update. Read More",
                              style: TextStyle(fontSize: 14.0, color: Colors.white),
                              textAlign: TextAlign.center,),
                          ]
                      )
                    )
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 140.0,
                        color: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFD2D2D2),
                                borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            child: new FlatButton(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(_incoming.toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,),
                                  new Text("Incoming",
                                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,),
                                ]
                              ),
                              onPressed: null,
                            )
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: 140.0,
                        color: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFD48032),
                                borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            child: new FlatButton(
                                child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(_pending.toString(),
                                        style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                      new Text("Pending",
                                        style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,),
                                    ]
                                ),
                                onPressed: null,
                            )
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  height: 100.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFB7CDFF),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      child: new FlatButton(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(_distributed.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,),
                              new Text("Distributed",
                                style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,),
                            ]
                        ),
                        onPressed: null,
                      )
                  ),
                ),
                Container(
                  height: 60.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                    color: Color(0xFF283568),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new FlatButton(
                      child: new Text("Inventory",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                      onPressed: null,
                    )
                  ),
                ),
              ]
            )
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text("Orders"),
//            icon: ImageIcon(
//              AssetImage("images/orders.png"),
//              color: Colors.white,
//            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
//            icon: ImageIcon(
//              AssetImage("images/home.png"),
//              color: Colors.white,
//            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
//            icon: ImageIcon(
//              AssetImage("images/settings.png"),
//              color: Colors.white,
//            ),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFF313F84),
        selectedItemColor: Color(0xFFEDA25D),
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 36,
        onTap: _onItemTapped,
      ),
    );
  }
}