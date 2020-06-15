import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/state_widgets.dart';
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
  String _userType = "COLLECTION HUB";
  String _message = "Alert: PPE Design Update. Read More";

  ItemConfirmationCard _itemConfirmationCard;
  int _newQuantity = 0;

  int _index = 0;

  bool _initialized = false;
  bool _addButtonPressed = false;
  bool _arrowPressed = false;
  bool _settingsEditButtonPressed = false;
  bool _inventoryEditButtonPressed = false;

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
      _selectedIndex = index;
      if (_selectedIndex != 0) {
        _index = 0;
      }
      _addButtonPressed = false;
      _arrowPressed = false;
      _settingsEditButtonPressed = false;
      _inventoryEditButtonPressed = false;
      _initialized = false;
      _displayInventory = true;
      _displaySettings = false;

      nameController.clear();
      emailController.clear();
      phoneNumberController.clear();
      addressController.clear();

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

  void _onInventoryEditButtonPressed() {
    _inventoryEditButtonPressed = !_inventoryEditButtonPressed;
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
    String firstName = user.getName().split(" ")[0];
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
        ),
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
        child: new SingleChildScrollView(
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
                      new ThreeToggle(
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
                        left: "Incoming",
                        middle: "Pending",
                        right: "Shipped",
                      ),
                      if (_displayIncoming) showIncomingItems(),
                      if (_displayPending) showPendingItems(),
                      if (_displayShipped) showShippedItems(),
                    ],
                  )
              )
          )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildProfilePage() {
    String _greeting = user.getName().split(" ")[0] + "'s Profile";

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
        child: new SingleChildScrollView(
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
                        new TwoToggle(
                          left: "Inventory",
                          right: "Settings",
                          onPressed: (int index) {
                            setState(() {
                              _isSelectedProfilePage[index] = true;
                              _isSelectedProfilePage[1 - index] = false;
                              _displayInventory = _isSelectedProfilePage[0];
                              _displaySettings = _isSelectedProfilePage[1];
                              if (_displayInventory) {
                                _settingsEditButtonPressed = false;
                              }
                            });
                          },
                          isSelected: _isSelectedProfilePage,
                        ),
                        if (_displayInventory) buildInventoryPage(),
                        if (_displaySettings) new ProfileSettings(user: user, title: ""),
                      ]
                  )
              )
          )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildInventoryPage() {
    String asset = "assets/images/face_shield_icon.png";
    String itemName = "Face Shield";
    int quantity = 5000;
    String itemType = "USCF V1";
    String itemType2 = "USCF V3";

    return new Padding (
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
            width: MediaQuery.of(context).size.width - 100,
            child: new Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new IconButton(
                          onPressed: _onInventoryEditButtonPressed,
                          icon: Image.asset("assets/images/edit_button.png", height: 26, alignment: Alignment.centerRight),
                        )
                      ]
                  ),
                  if (!_inventoryEditButtonPressed) new InventoryCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType,),
                  if (!_inventoryEditButtonPressed) new InventoryCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType2,),
                  if (_inventoryEditButtonPressed) new InventoryEditCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType),
                  if (_inventoryEditButtonPressed) new InventoryEditCard(asset: asset, itemName: itemName, quantity: quantity, itemType: itemType2),
                  if (_inventoryEditButtonPressed) new Row (
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
                                  _inventoryEditButtonPressed = false;
                                  build(context);
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
                                _inventoryEditButtonPressed = false;
                                build(context);
                              },
                            )
                        ),
                      ]
                  )
                ]
            )
        ),
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

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
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