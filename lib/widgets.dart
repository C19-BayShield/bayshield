import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';

class BayShieldAppBar extends StatelessWidget {
  final String title;
  BayShieldAppBar({Key key, @required this.title}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        title: new Text(title),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
    ); 
  }
}

class MainAppBar extends StatelessWidget {
  final VoidCallback signOut;

  MainAppBar({Key key, @required this.signOut}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Color(0xFF313F84),
      title: Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Image.asset(
            'assets/images/logo.png', color: Colors.white, height: 60),
      ),
      actions: <Widget>[
        new FlatButton(
            child: new Text('Logout',
                style: new TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: signOut
        ),
      ],
    );
  }
}

class UserTypeTag extends StatelessWidget {
  final String userTag;

  UserTypeTag({Key key, @required this.userTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height / 22,
      width: (MediaQuery.of(context).size.width + 25) / 2,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFd48032).withOpacity(0.25),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: new Center(
          child: new Text(userTag,
            style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
        )
      )
    );
  }
}

class AlertTag extends StatelessWidget {
  final String message;

  AlertTag({Key key, @required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  new Text(message,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                    textAlign: TextAlign.center,),
                ]
            )
        )
    );
  }
}

class IncomingOrdersCard extends StatelessWidget {
  final int incoming;

  IncomingOrdersCard({Key key, @required this.incoming}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFD2D2D2),
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: new FlatButton(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(incoming.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                new Text("Incoming",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
              ]
          ),
          onPressed: null,
        )
    );
  }
}

class PendingOrdersCard extends StatelessWidget {
  final int pending;

  PendingOrdersCard({Key key, @required this.pending}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFD48032),
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: new FlatButton(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(pending.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                new Text("Pending",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
              ]
          ),
          onPressed: null,
        )
    );
  }
}

class DistributedOrdersCard extends StatelessWidget {
  final int distributed;

  DistributedOrdersCard({Key key, @required this.distributed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFB7CDFF),
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: new FlatButton(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(distributed.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                new Text("Distributed",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
              ]
          ),
          onPressed: null,
        )
    );
  }
}

class InventoryButton extends StatelessWidget {
  final Function() onPressed;

  InventoryButton({Key key, @required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width - 110,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF283568),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: new FlatButton(
            child: new Text("Inventory",
              style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,),
            onPressed: onPressed,
          )
      ),
    );
  }
}

class MainBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  MainBottomNavigationBar({Key key, @required this.selectedIndex, this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("assets/images/orders.png"),
          ),
          title: Text("Orders")
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("assets/images/home.png"),
          ),
          title: Text("Home")
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("assets/images/settings.png"),
          ),
          title: Text("Settings")
        ),
      ],
      currentIndex: selectedIndex,
      backgroundColor: Color(0xFF313F84),
      selectedItemColor: Color(0xFFEDA25D),
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 36,
      onTap: onItemTapped,
    );
  }
}

class FullScreenCover extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
     return Container(
      height: screenSize.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/landingcover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  // This widget is the root of your application.
  final VoidCallback submit;
  final String label;
  PrimaryButton({Key key, @required this.submit, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 30.0,
          child: new FlatButton(
            child: new Text(label,
                style: new TextStyle(fontSize: 20.0, color: Color(0xFFF4BA5B))),
            onPressed: submit,
          ),
        ));
  }
}

class BayShieldFormField extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final String hint;
  final IconData icon;
  final bool obscureText;
  BayShieldFormField({Key key, this.obscureText, @required this.validator, this.onSaved, this.hint, this.icon}) : super(key: key);

  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: new TextFormField(
        style: new TextStyle(
              color: Colors.black,
        ),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: this.obscureText ?? false,
        decoration: new InputDecoration(
            hintText: hint,
            hintStyle:  new TextStyle(
              color: Colors.grey,
            ),
            icon: new Icon(
              icon,
              color: Colors.grey[700],
            ),
            enabledBorder: UnderlineInputBorder(      
              borderSide: BorderSide(color: Colors.grey),   
              ),  
          ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
      
}