import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:intl/intl.dart';

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

  MainAppBar({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Color(0xFF313F84),
      title: Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Image.asset(
            'assets/images/logo.png', color: Colors.white, height: 64),
      ),
//      actions: <Widget>[
//        new FlatButton(
//            child: new Text('Logout',
//                style: new TextStyle(fontSize: 17.0, color: Colors.white)),
//            onPressed: signOut,
//        ),
//      ],
    );
  }
}

class UserTypeTag extends StatelessWidget {
  final String userTag;

  UserTypeTag({Key key, @required this.userTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height / 25,
      width: (MediaQuery.of(context).size.width + 25) / 2,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFd48032).withOpacity(0.25),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: new Center(
          child: new Text(userTag,
            style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', 
            fontWeight: FontWeight.bold, letterSpacing: 2.0),
            textAlign: TextAlign.center,),
        )
      )
    );
  }
}

class UserTypeTagBlue extends StatelessWidget {
  final String userTag;

  UserTypeTagBlue({Key key, @required this.userTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 6.0),
      color: Colors.transparent,
      child: Container(
        padding: new EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
            color: Color(0xFF697CC8), 
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: new Text(userTag.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 15, 
              fontFamily: 'Roboto', fontWeight: FontWeight.bold, letterSpacing: 2.0),
              textAlign: TextAlign.center,),
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

class IncomingItemsCard extends StatelessWidget {
  final int incoming;
  final Function() onPressed;

  IncomingItemsCard({Key key, @required this.incoming, @required this.onPressed}) : super(key: key);
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
          onPressed: onPressed,
        )
    );
  }
}

class PendingItemsCard extends StatelessWidget {
  final int pending;
  final Function() onPressed;

  PendingItemsCard({Key key, @required this.pending, @required this.onPressed}) : super(key: key);
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
          onPressed: onPressed,
        )
    );
  }
}

class ShippedItemsCard extends StatelessWidget {
  final int shipped;
  final Function() onPressed;

  ShippedItemsCard({Key key, @required this.shipped, @required this.onPressed}) : super(key: key);
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
                new Text(shipped.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                new Text("Shipped",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
              ]
          ),
          onPressed: onPressed,
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

class NewOrderButton extends StatelessWidget {
  final Function() onPressed;

  NewOrderButton ({Key key, @required this.onPressed}) : super(key: key);
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
            child: new Text("New Order",
              style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,),
            onPressed: onPressed,
          )
      ),
    );
  }
}

class NewOrderPlus extends StatelessWidget {
  final Function() onPressed;

  NewOrderPlus ({Key key, @required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 8, left: 32),
      alignment: Alignment.centerLeft,
      child: Container(
          child: new FlatButton.icon(
            icon: Icon(Icons.add_circle, color: Color(0XFFB7CDFF), size: 48.0), 
            label: new Text("   Add Order",
              style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Roboto',),
              textAlign: TextAlign.left,),
            onPressed: onPressed,
          )
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String asset;
  final String itemName;
  final int quantity;
  final String itemType;
  final String date;
  final String icon;
  final bool hasShipped;
  final bool isPending;
  final String status;
  final String deliveryDate;
  final String deliveryLocation;

  final Function() onPressed;

  ItemCard({Key key, @required this.asset, @required this.itemName, @required this.quantity, @required this.itemType,
    @required this.isPending, @required this.hasShipped, this.date, this.onPressed, this.icon, this.status,
    this.deliveryDate, this.deliveryLocation,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          Image.asset(asset, height: 70),
          new Padding (
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(itemName,
                    style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,),
                  new Row(
                      children: <Widget>[
                        new Text("QTY:" + quantity.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                        new Padding (
                          padding: EdgeInsets.only(left: 8.0),
                          child: new Text(itemType,
                            style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                        )
                      ]
                  ),
                  if (!isPending) new Text(date,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                ]
            ),
          ),
          Spacer(),
          if (!hasShipped) new IconButton(
            onPressed: onPressed,
            icon: Image.asset(icon, height: 26, alignment: Alignment.centerRight),
          ),
          if (hasShipped) Column(
            children: <Widget>[
              new Text(status,
                style: TextStyle(color: Color(0xFF555555), fontSize: 14, fontFamily: 'Roboto'), textAlign: TextAlign.center,),
              new Text(deliveryDate,
                style: TextStyle(color: Color(0xFF555555), fontSize: 14, fontFamily: 'Roboto'), textAlign: TextAlign.center,),
              new Text(deliveryLocation,
                style: TextStyle(color: Color(0xFF555555), fontSize: 14, fontFamily: 'Roboto'), textAlign: TextAlign.center,)
            ]
          )
        ]
    );
  }
}

class ItemConfirmationCard extends StatelessWidget {
  final String asset;
  final String itemName;
  final int quantity;
  final String itemType;

  ItemConfirmationCard({Key key, @required this.asset, @required this.itemName, @required this.quantity, @required this.itemType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Image.asset(asset, height: 70),
        new Padding (
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(itemName,
                    style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),
                ]
              ),
              new Row(
                children: <Widget>[
                  new Text("QTY:" + quantity.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                  new Padding (
                    padding: EdgeInsets.only(left: 8.0),
                    child: new Text(itemType,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                  )
                ]
              ),
            ]
          ),
        ),
      ]
    );
  }
}

class InventoryCard extends StatelessWidget {
  final String asset;
  final String itemName;
  final int quantity;
  final String itemType;

  InventoryCard({Key key, @required this.asset, @required this.itemName, @required this.quantity, @required this.itemType,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          Image.asset(asset, height: 70),
          new Padding (
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(itemType + " " + itemName,
                    style: TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,),
                  new Text(quantity.toString() + " COUNT",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                ]
            ),
          ),
        ]
    );
  }
}

class InventoryEditCard extends StatelessWidget {
  final String asset;
  final String itemName;
  final int quantity;
  final String itemType;
  final TextEditingController controller;

  InventoryEditCard({Key key, @required this.asset, @required this.itemName, @required this.quantity, @required this.itemType, @required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Row(
        children: <Widget>[
          Image.asset(asset, height: 70),
          new Padding (
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(itemType + " " + itemName,
                    style: TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,),
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new TextField(
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          autofocus: false,
                          decoration: new InputDecoration(
                              hintText: quantity.toString(),
                              hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black)
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black)
                              )
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: controller,
                        ),
                      )
                  ),
                  SizedBox(height: 10),
                ]
            ),
          ),
        ]
    );
  }
}

class QuantityInputField extends StatelessWidget {
  final Function(String) onChanged;

  QuantityInputField({Key key, @required this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding (
            padding: EdgeInsets.only(top: 64, bottom: 24),
            child: new Text("QUANTITY", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,),
          ),
          new Container (
            child: new TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              scrollPadding: EdgeInsets.symmetric(horizontal: 16),
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                labelText: "Ex. 100",
                labelStyle: TextStyle(
                    color: Color(0xFFB3B3B3)
                ),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                ),
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                )
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: onChanged,
            ),
          ),
        ]
    );
  }
}

class MainBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  MainBottomNavigationBar({Key key, @required this.selectedIndex, @required this.onItemTapped}) : super(key: key);

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
          title: Text("Profile")
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
          image: AssetImage('assets/images/login_bg.png'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
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
     return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: new FlatButton(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        textColor: Colors.black,
        color: Color(0xFFD48032),
        child: new Text(label,
            style: new TextStyle(fontSize: 24.0),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        onPressed: submit,
      )
    );
  }
}


class SecondaryButton extends StatelessWidget {
  // This widget is the root of your application.
  final VoidCallback submit;
  final String label;
  SecondaryButton({Key key, @required this.submit, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     return Container(
      child: new FlatButton(
        textColor: Colors.white,
        child: new Text(label,
            style: new TextStyle(fontSize: 18.0, decoration: TextDecoration.underline),
        ),
        onPressed: submit,
      )
    );
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
          color: Colors.white,
        ),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: this.obscureText ?? false,
        decoration: new InputDecoration(
          hintText: hint,
          hintStyle: new TextStyle(
            color: Colors.grey,
          ),
          icon: new Icon(
            icon,
            color: Colors.white,
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

class EditFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hint;
  final List<TextInputFormatter> formatter;
  final int maxLines;
  EditFormField({Key key, @required this.controller, @required this.type, @required this.hint, this.formatter, @required this.maxLines}) : super(key: key);

  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: new TextField(
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.left,
        maxLines: maxLines,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)
            ),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.black)
            )
        ),
        keyboardType: type,
        controller: controller,
        inputFormatters: formatter,
        onChanged: null,
      ),
    );
  }
}

class ThreeToggle extends StatelessWidget {
  final Function(int) onPressed;
  final List<bool> isSelected;
  final String left;
  final String middle;
  final String right;

  ThreeToggle({Key key, @required this.onPressed, @required this.isSelected,
    @required this.left, @required this.middle, @required this.right,}) : super(key: key);

  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
        color: Color(0xFFD2D2D2),
      ),
      child: ToggleButtons(
        fillColor: Color(0xFFB7CDFF),
        borderWidth: 0.0,
        constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 110) / 3, minHeight: MediaQuery.of(context).size.height / 25),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        children: <Widget>[
          new Text(left, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          new Text(middle, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          new Text(right, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
        ],
        onPressed: onPressed,
        isSelected: isSelected,
      ),
    );
  }
}

class TwoToggle extends StatelessWidget {
  final Function(int) onPressed;
  final List<bool> isSelected;
  final String left;
  final String right;

  TwoToggle({Key key, @required this.onPressed, @required this.isSelected,
    @required this.left, @required this.right,}) : super(key: key);

  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFD2D2D2),
      ),
      child: ToggleButtons(
        fillColor: Color(0xFFB7CDFF),
        borderWidth: 0.0,
        constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 110)/2, minHeight: MediaQuery.of(context).size.height / 25),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        children: <Widget>[
          new Text(left, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          new Text(right, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
        ],
        onPressed: onPressed,
        isSelected: isSelected,
      ),
    );
  }
}

/* Order Cards BEGIN */

class OrderCard extends StatelessWidget {

  final Function() onPressed;
  final Function(String) onChanged;
  final String asset;

  OrderCard({Key key, @required this.onPressed, @required this.onChanged, @required this.asset}) : super(key: key);

  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new Container(
          height: 150,
          width: 145,
          decoration: BoxDecoration(
            color: Color(0xFF283568),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        new Container(
            height: 150,
            width: 145,
            alignment: Alignment.bottomCenter,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                      alignment: Alignment.bottomCenter,
                      child: new Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: new Text("QUANTITY", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.bold),),
                      )
                  ),
                  new Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: new Container(
                        alignment: Alignment.bottomRight,
                        width: 50,
                        child: new TextField(
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          autofocus: false,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white, width: 2)
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white, width: 2)
                              )
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: onChanged,
                        ),
                      )
                  )
                ]
            )
        ),
        new Container(
          height: 115,
          width: 145,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
            border: Border.all(
              color: Color(0xFF283568),
              width: .5,
            ),
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(5),
          child: new Container(
            height: 105,
            width: 105,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        )
      ]
    );
  }
}

class OrderConfirmationCard extends StatelessWidget {
  final String asset;
  final String itemName;
  final int quantity;
  final String itemType;

  OrderConfirmationCard({Key key, @required this.asset, @required this.itemName, @required this.quantity,
    @required this.itemType,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(bottom: 16, right: 16),
          child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    border: Border.all(
                      color: Color(0xFF283568),
                      width: .5,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(5),
                  child: new Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asset),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                )
              ]
          ),
        ),
        new Container (
          width: (MediaQuery.of(context).size.width - 130) / 2,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(itemName.toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto',), textAlign: TextAlign.left,),
                SizedBox(height: 5),
                new Text(itemType.toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
              ]
          ),
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              alignment: Alignment.centerRight,
              child: new Text(quantity.toString() + "X",
                style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Roboto', fontWeight: FontWeight.bold), textAlign: TextAlign.left,)
            )
          ]
        )
      ]
    );
  }
}

class RequestCard extends StatelessWidget {

  final SupplyRequest req;
  final SupplyOrder order;
  final Function onDelete;

  RequestCard({Key key, @required this.req, @required this.order, @required this.onDelete}) : super(key: key);

  String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
    ? myString
    : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    Item item = req.item; 
    DateTime date = order.timestamp.toDate();
    String formattedDate = new DateFormat.yMd().format(date);
    return new Row(
        children: <Widget>[
          Image.asset(item.imageUrl, height: 70),
          new Padding (
            padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(item.name,
                    style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,),
                  new Row(
                      children: <Widget>[
                        new Text("x" + req.amtOrdered.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                      ]
                  ),
                  new Text(formattedDate,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                ]
            ),
          ),
          Spacer(),
          new IconButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) => onDelete(context, order, req),
              )
            },
            icon: Icon(Icons.cancel),
            color: Color(0xFFC4C4C4),
            iconSize: 24.0,
          ),
        ]
    );
  }
}

/* Order Cards END */