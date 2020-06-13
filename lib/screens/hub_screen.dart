import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/firestore_users.dart';

class HubScreen extends StatefulWidget {

  HubScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HubScreenState();

}

class _HubScreenState extends State<HubScreen>{
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  int _selectedIndex = 1; // default loads Home Page.

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // TODO: Replace hard coded values
  int _incoming = 10;
  int _pending = 35;
  int _shipped = 13430;
  String _userType = "C O L L E C T I O N  H U B";
  String _message = "Alert: PPE Design Update. Read More";

  ItemConfirmationCard _itemConfirmationCard;
  int _newQuantity = 0;

  int _index = 0;

  bool _initialized = false;
  bool _addButtonPressed = false;
  bool _arrowPressed = false;
  bool _editButtonPressed = false;

  List<bool> _isSelectedOrdersPage = [true, false, false]; // defaults at Incoming tab.
  bool _displayIncoming = true;
  bool _displayPending = false;
  bool _displayShipped = false;

  List<bool> _isSelectedProfilePage = [true, false]; // defaults at Inventory tab.
  bool _displayInventory = true;
  bool _displaySettings = false;

  // User variables
  User user;

  void _onNavigationIconTapped(int index) {
    setState(() {
      _index = 0;
      _selectedIndex = index;
      _addButtonPressed = false;
      _arrowPressed = false;
      _editButtonPressed = false;
      _initialized = false;
      _displayInventory = true;
      _displaySettings = false;

      _isSelectedProfilePage[0] = _displayInventory;
      _isSelectedProfilePage[1] = _displaySettings;
      build(context);
    });
  }

  void _onInventoryPressed() {
    _onNavigationIconTapped(2);
  }

  void _onIncomingPressed() {
    _index = 0;
    _onNavigationIconTapped(0);
  }

  void _onPendingPressed() {
    _index = 1;
    _onNavigationIconTapped(0);
  }

  void _onShippedPressed() {
    _index = 2;
    _onNavigationIconTapped(0);
  }

  void _onAddButtonPressed(ItemConfirmationCard card) {
    _itemConfirmationCard = card;
    _selectedIndex = 0;
    _addButtonPressed = true;
    _initialized = false;
    build(context);
  }

  void _onArrowPressed(ItemConfirmationCard card) {
    _itemConfirmationCard = card;
    _selectedIndex = 0;
    _arrowPressed = true;
    _initialized = false;
    build(context);
  }

  void _onEditButtonPressed() {
    _selectedIndex = 2;
    _editButtonPressed = true;
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

  Widget showIncomingItems() {
    // TODO: replace hard-coded values.
    String asset = "assets/images/face_shield_icon.png";
    String icon = "assets/images/add_button.png";
    String itemName = "Face Shield";
    int quantity = 50;
    String itemType = "USCF V1";
    String date = "02/01/2020";

    return new Padding (
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 80,
        child: new Column (
          children: <Widget> [
            new ItemCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType, date: date, icon: icon,
                hasShipped: false, isPending: false, onPressed: () {
                _onAddButtonPressed(new ItemConfirmationCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType));
              }),
          ]
        )
      )
    );
  }

  Widget showPendingItems() {
    // TODO: replace hard-coded values.
    String asset = "assets/images/face_shield_icon.png";
    String icon = "assets/images/arrow.png";
    String itemName = "Face Shield";
    int quantity = 50;
    String itemType = "USCF V3";

    return new Padding (
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 80,
        child: new Column (
          children: <Widget> [
            new ItemCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType, icon: icon, hasShipped: false, isPending: true,
              onPressed: () {
                _onArrowPressed(new ItemConfirmationCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType));
              }),
          ]
        )
      )
    );
  }

  Widget showShippedItems() {
    // TODO: replace hard-coded values.
    String asset = "assets/images/face_shield_icon.png";
    String itemName = "Face Shield";
    int quantity = 50;
    String itemType = "USCF V1";
    String date = "02/01/2020";
    String status = "Expected\nDelivery";
    String deliveryDate = "02/06/2020";
    String deliveryLocation = "Tang Center";

    return new Padding (
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Container(
            width: MediaQuery.of(context).size.width - 80,
            child: new Column (
                children: <Widget> [
                  new ItemCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType, date: date, hasShipped: true, isPending: false,
                    status: status, deliveryDate: deliveryDate, deliveryLocation: deliveryLocation),
                ]
            )
        )
    );
  }

  Widget _buildConfirmationPopUp(BuildContext context, String itemName, int quantity) {
    if (quantity == 0) {
      return new AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black),
        title: Text("Please input a quantity greater than zero."),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Color(0xFF283568),
            child: const Text('Close'),
          ) ,
        ],
      );
    }
    return new AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black),
      title: Text('Are you sure you want to add ' + quantity.toString() + " " + itemName + " to your inventory? You cannot undo this action."),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Color(0xFF283568),
          child: const Text('Yes'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Color(0xFF283568),
          child: const Text('No'),
        ) ,
      ],
    );
  }

  Widget buildConfirmationPage() {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
        child: new Container(
          child: Center(
            child: new SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width - 110,
                    color: Colors.transparent,
                    child: new Padding(
                      child: new Text("Confirmation", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      padding: EdgeInsets.only(bottom: 25)
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width - 110,
                    child: _itemConfirmationCard,
                  ),
                  new Container(
                      width: MediaQuery.of(context).size.width - 110,
                      child: new QuantityInputField(onChanged: (value) {
                        _newQuantity = int.parse(value);
                      }),
                  ),
                  new Padding (
                    padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: new Container(
                      width: MediaQuery.of(context).size.width - 110,
                      decoration: BoxDecoration(
                        color: Color(0xFF283568),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: new FlatButton(
                        child: new Text("Add to Inventory",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildConfirmationPopUp(context, _itemConfirmationCard.itemName, _newQuantity),
                          );
                        },
                      )
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width - 110,
                    child: new FlatButton(
                      child: new Text("Back",
                        style: TextStyle(color: Color(0xFFD48032), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,),
                      onPressed: () {
                        _addButtonPressed = false;
                        _onIncomingPressed();
                      },
                    )
                  ),
                ]
              )
            )
          )
        )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildShippingPage() {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
          child: new Container(
              child: Center(
                  child: new SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width - 110,
                              color: Colors.transparent,
                              child: new Padding(
                                  child: new Text("Shipping", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,),
                                  padding: EdgeInsets.only(bottom: 25)
                              ),
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width - 110,
                              child: _itemConfirmationCard,
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width - 110,
                              child: new QuantityInputField(onChanged: (value) {
                                _newQuantity = int.parse(value);
                              }),
                            ),
                            new Padding (
                              padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
                              child: new Container(
                                  width: MediaQuery.of(context).size.width - 110,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF283568),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  child: new FlatButton(
                                    child: new Text("Print Shipping Label",
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,),
                                    onPressed: () {

                                    },
                                  )
                              ),
                            ),
                            new Container(
                                width: MediaQuery.of(context).size.width - 110,
                                child: new FlatButton(
                                  child: new Text("Back",
                                    style: TextStyle(color: Color(0xFFD48032), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                    textAlign: TextAlign.center,),
                                  onPressed: () {
                                    _arrowPressed = false;
                                    _onPendingPressed();
                                  },
                                )
                            ),
                          ]
                      )
                  )
              )
          )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildHomePage() {
    String firstName = user.name.split(" ")[0];
    String _greeting = "Hi, " + firstName + ".";

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
                if (_displayIncoming) showIncomingItems(),
                if (_displayPending) showPendingItems(),
                if (_displayShipped) showShippedItems(),
              ],
            )
          )
        )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildProfilePage() {
    String _greeting = user.name.split(" ")[0] + "'s Profile";

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
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
                    child: new Text(_greeting, style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
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
                      if (_displayInventory) {
                        _editButtonPressed = false;
                      }
                    });
                  },
                  isSelected: _isSelectedProfilePage,
                ),
                if (_displayInventory) new Text("Inventory", style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),
                if (_displaySettings) showSettings(),
              ]
            )
          )
        )
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  Future getUser() async {
    User currUser = await _firestoreUsers.getUser(widget.userId);

    if (currUser != null) {
      if (!mounted) return;
      setState(() {
        user = currUser;
      });
    }
  }

  Widget showSettings() {
    return new Padding (
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: new Column (
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new IconButton(
                  onPressed: _onEditButtonPressed,
                  icon: Image.asset("assets/images/edit_button.png", height: 26, alignment: Alignment.centerRight),
                )
              ]
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Name", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      SizedBox(height: 29),
                      new Text("Email", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      SizedBox(height: 29),
                      new Text("Phone", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      SizedBox(height: 29),
                      new Text("Address", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                    ]
                  ),
                ),
                if (!_editButtonPressed)
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(user.name, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,),
                        SizedBox(height: 29),
                        new Text(user.email, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,),
                        SizedBox(height: 29),
                        new Text(user.phoneNumber, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,),
                        SizedBox(height: 29),
                        new Text(user.address, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,),
                      ]
                  ),
                if (_editButtonPressed) buildEditProfilePage(),
              ]
            ),
            SizedBox(height: 30),
            if (_editButtonPressed)
              new Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding (
                      padding: EdgeInsets.only(right: 4),
                      child: new Container(
                          width: (MediaQuery.of(context).size.width - 120) * 0.5,
                          child: new FlatButton(
                            child: new Text("Save",
                              style: TextStyle(color: Color(0xFF283568), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,),
                            onPressed: () {
                              updateUser();
                              _editButtonPressed = false;
                              showSettings();
                            },
                          )
                      ),
                    ),
                    new Container(
                        width: (MediaQuery.of(context).size.width - 120) * 0.5,
                        child: new FlatButton(
                          child: new Text("Cancel",
                            style: TextStyle(color: Color(0xFFD48032), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,),
                          onPressed: () {
                            _editButtonPressed = false;
                            showSettings();
                          },
                        )
                    ),
                  ]
              )
          ]
        )
      )
    );
  }

  Widget buildEditProfilePage() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                hintText: user.name,
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                ),
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                )
              ),
              keyboardType: TextInputType.text,
              controller: nameController,
              onChanged: null,
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                hintText: user.email,
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                ),
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                )
              ),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              onChanged: null,
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                hintText: user.phoneNumber,
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
              controller: phoneNumberController,
              onChanged: null,
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: new TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                hintText: user.address,
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                ),
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)
                )
              ),
              controller: addressController,
              onChanged: null,
            ),
          ),
      ]
    );
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void updateUser() async {
    await _firestoreUsers.setUserName(widget.userId, nameController.text == "" ? user.name : nameController.text);
    await _firestoreUsers.setUserEmail(widget.userId, emailController.text == "" ? user.email : emailController.text);
    await _firestoreUsers.setUserPhoneNumber(widget.userId, phoneNumberController.text == "" ? user.phoneNumber : phoneNumberController.text);
    await _firestoreUsers.setUserAddress(widget.userId, addressController.text == "" ? user.address : addressController.text);
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    if (user == null) {
      return buildWaitingScreen();
    } else {
      if (_selectedIndex == 0) {
        if (_addButtonPressed) {
          return buildConfirmationPage();
        } else if (_arrowPressed) {
          return buildShippingPage();
        }
        return buildOrdersPage();
      } else if (_selectedIndex == 1) {
        return buildHomePage();
      } else if (_selectedIndex == 2) {
        return buildProfilePage();
      }
    }
  }
}