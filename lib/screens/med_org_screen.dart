import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/mock_consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/state_widgets.dart';


class MedicalOrganizationScreen extends StatefulWidget {

  MedicalOrganizationScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MedicalOrganizationScreenState();
}

class _MedicalOrganizationScreenState extends State<MedicalOrganizationScreen> {

  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  MedicalFacility user;
  int _selectedIndex = 1; // default loads Home Page.

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextStyle orderStyle = TextStyle(fontSize: 16.0,letterSpacing: .5, color: Color(0xFF263151));
  TextStyle orderSubtitleStyle = TextStyle(fontSize: 14.0,letterSpacing: .5, color: Color(0xFFA5A9B4));
  String _message = "Alert: PPE Design Update. Read More";
  int _pending = 4;
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

  bool _newOrder = false;
  bool _quantitiesChosen = false;

  bool _displaySettings = true;
  bool _displayStatus = false;
  List<bool> _isSelectedProfilePage = [true, false];

  // Order quantities
  int faceShieldCount = 0;
  int n95Count = 0;
  int glovesCount = 0;
  int gogglesCount = 0;
  int gownCount = 0;
  int sanitizerCount = 0;


  void _onNavigationIconTapped(int index) {
    setState(() {
      _index = 0;
      _selectedIndex = index;
      _addButtonPressed = false;
      _arrowPressed = false;
      _editButtonPressed = false;
      _initialized = false;
      _displayStatus = false;
      _displaySettings = true;
      _newOrder = false;
      _quantitiesChosen = false;

      nameController.clear();
      emailController.clear();
      phoneNumberController.clear();
      addressController.clear();

      resetQuantities();

      _isSelectedProfilePage[0] = _displaySettings;
      _isSelectedProfilePage[1] = _displayStatus;
      build(context);
    });
  }

  void resetQuantities() {
    faceShieldCount = 0;
    n95Count = 0;
    glovesCount = 0;
    gogglesCount = 0;
    gownCount = 0;
    sanitizerCount = 0;
  }


  Future getUser() async {
    MedicalFacility currUser = await _firestoreUsers.getMedicalFacility(widget.userId);
    if (currUser != null) {
      if (!mounted) return;
      setState(() {
        user = currUser;
      });
    }
  }

  Widget _buildRequestItem(SupplyRequest req, BuildContext context) {
    String asset = req.item.imageUrl ?? "assets/images/logo.png";
    String itemName =  req.item.name;
    int quantity = req.amtOrdered;

    return new ItemCard(asset: asset, itemName: itemName, quantity: quantity, 
      itemType: "USCF V1", date: "06 May 2020", hasShipped: true, isPending: false,
      status: req.statusToString(),  
      deliveryLocation: user.getFacilityName(),
      deliveryDate: "10 May 2020",
    );
  }

    Widget showShippedItems() {
    // TODO: replace hard-coded values.
    String asset = "assets/images/face_shield_card.png";
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

  Widget _buildRequestList() {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
            for(final req in TEST_REQS)
        Padding(child: _buildRequestItem(req, context),padding: EdgeInsets.symmetric(vertical: 8)),         
        ], 
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

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  void _onPendingPressed() {
    _index = 1;
    _onNavigationIconTapped(0);
  }

  Widget buildHomePage() {
    String firstName = user.getName().split(" ")[0];
    String _greeting = "Hi, " + firstName + ".";
    if (user == null) {
      return buildWaitingScreen();
    } else {
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
                          new UserTypeTag(userTag: user.getFacilityName() ?? ""),
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
                                      child: new PendingItemsCard(pending: _pending, onPressed: _onPendingPressed),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 7,
                                      width: (MediaQuery.of(context).size.width - 120) / 2,
                                      color: Colors.transparent,
                                      child: new ShippedItemsCard(shipped: 100, onPressed: () => {}),
                                    ),
                                  ]
                              )
                          ),
                          new NewOrderButton(onPressed: () {
                            _newOrder = true;
                            _selectedIndex = 0;
                            build(context);
                          }),
                           Container(
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.width - 110,
                              color: Colors.transparent,
                            ),
                        ]
                    )
                )
            ),
          ),
          bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
        );
      }
  }

  Widget buildProfilePage() {
    String _greeting = "Settings";

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
                                child: new Text(_greeting, style: TextStyle(color: Colors.black, 
                                fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,),
                                padding: EdgeInsets.only(top: 30, bottom: 25)
                            )
                        ),
                        TwoToggle(
                          left: "Profile",
                          right: "Status",
                          onPressed: (int index) {
                            setState(() {
                              _isSelectedProfilePage[index] = true;
                              _isSelectedProfilePage[1 - index] = false;
                              _displaySettings = _isSelectedProfilePage[0];
                              _displayStatus = _isSelectedProfilePage[1];
                              if (_displaySettings) {
                                _editButtonPressed = false;
                              }
                            });
                          },
                          isSelected: _isSelectedProfilePage,
                        ),
                        if (_displayStatus) new MedorgsStatus(user: user),
                        if (_displaySettings) new ProfileSettings(user: user, title: "Personal Information"),
                      ]
                  )
              )
          )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildOrdersPage() {
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
                     showShippedItems(),
                     new NewOrderPlus(onPressed: () {
                       _newOrder = true;
                       _selectedIndex = 0;
                       build(context);
                     }),
                    ],
                  )
              )
          )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildNewOrdersPage() {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: SafeArea(
          child: new SingleChildScrollView(
            child: Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width - 110,
                            color: Colors.transparent,
                            child: new Padding(
                                child: new Text("New Order", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,),
                                padding: EdgeInsets.only(top: 30, bottom: 15)
                            ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width - 110,
                            color: Colors.transparent,
                            child: new Padding(
                                child: new Text("SELECT ITEMS", style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,),
                                padding: EdgeInsets.only(bottom: 25)
                            ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: new Column(
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        OrderCard(
                                          asset: "assets/images/face_shield_icon.png",
                                          onChanged: (value) {
                                            faceShieldCount = int.parse(value);
                                          },
                                        ),
                                        OrderCard(
                                          asset: "assets/images/gloves_icon.png",
                                          onChanged: (value) {
                                            glovesCount = int.parse(value);
                                          },
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 20),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        OrderCard(
                                          asset: "assets/images/goggles_icon.png",
                                          onChanged: (value) {
                                            gogglesCount = int.parse(value);
                                          },
                                        ),
                                        OrderCard(
                                          asset: "assets/images/gown_icon.png",
                                          onChanged: (value) {
                                            gownCount = int.parse(value);
                                          },
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 20),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        OrderCard(
                                          asset: "assets/images/n95_icon.png",
                                          onChanged: (value) {
                                            n95Count = int.parse(value);
                                          },
                                        ),
                                        OrderCard(
                                          asset: "assets/images/sanitizer_icon.png",
                                          onChanged: (value) {
                                            sanitizerCount = int.parse(value);
                                          },
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 30),
                                  new Container(
                                      width: MediaQuery.of(context).size.width - 110,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF283568),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: new FlatButton(
                                        child: new Text("Next",
                                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,),
                                        onPressed: () {
                                          int total = sanitizerCount + gogglesCount + glovesCount + gownCount + faceShieldCount + n95Count;
                                          if (total == 0) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _buildPopUp(context),
                                            );
                                          } else {
                                            _quantitiesChosen = true;
                                            build(context);
                                          }
                                        },
                                      )
                                  ),
                                  SizedBox(height: 20),
                                ]
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

  Widget buildOrderSummaryPage() {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(signOut: signOut),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
              child: new SingleChildScrollView(
                  child: Container(
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width - 110,
                                  color: Colors.transparent,
                                  child: new Padding(
                                      child: new Text("New Order", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,),
                                      padding: EdgeInsets.only(top: 30, bottom: 15)
                                  ),
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width - 110,
                                  color: Colors.transparent,
                                  child: new Padding(
                                      child: new Text("ORDER SUMMARY", style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,),
                                      padding: EdgeInsets.only(bottom: 25)
                                  ),
                                ),
                                new Container(
                                    width: MediaQuery.of(context).size.width - 80,
                                    child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          if (faceShieldCount > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/face_shield_icon.png",
                                              itemName: "Face Shield",
                                              itemType: "USCF V1",
                                              quantity: faceShieldCount,
                                            ),
                                          if (n95Count > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/n95_icon.png",
                                              itemName: "N95 Mask",
                                              itemType: "3M, MFD 2019",
                                              quantity: n95Count,
                                            ),
                                          if (glovesCount > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/gloves_icon.png",
                                              itemName: "Gloves",
                                              itemType: "Surgical",
                                              quantity: glovesCount,
                                            ),
                                          if (gogglesCount > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/goggles_icon.png",
                                              itemName: "Goggles",
                                              itemType: "Surgical",
                                              quantity: gogglesCount,
                                            ),
                                          if (gownCount > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/gown_icon.png",
                                              itemName: "Gown",
                                              itemType: "Regular",
                                              quantity: gownCount,
                                            ),
                                          if (sanitizerCount > 0)
                                            OrderConfirmationCard(
                                              asset: "assets/images/sanitizer_icon.png",
                                              itemName: "Sanitizer",
                                              itemType: "Hand Sanitizer",
                                              quantity: sanitizerCount,
                                            ),
                                        ]
                                    )
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  alignment: Alignment.centerLeft,
                                  child: new Padding (
                                    padding: EdgeInsets.only(top: 30),
                                    child: new Text("SPECIAL INSTRUCTIONS", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,),
                                  ),
                                ),
                                new Container (
                                  width: MediaQuery.of(context).size.width - 100,
                                  alignment: Alignment.centerLeft,
                                  child: new TextField(
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left,
                                    scrollPadding: EdgeInsets.symmetric(horizontal: 16),
                                    maxLines: 1,
                                    autofocus: false,
                                    decoration: new InputDecoration(
                                      hintText: "Enter here",
                                      hintStyle: new TextStyle(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.black)
                                      )
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: null,
                                  ),
                                ),
                                SizedBox(height: 20),
                                new Container(
                                  width: MediaQuery.of(context).size.width - 110,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFD48032),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  child: new FlatButton(
                                    child: new Text("Complete Order",
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,),
                                    onPressed: () {
                                      _quantitiesChosen = false;
                                      _newOrder = false;
                                      resetQuantities();
                                      build(context);
                                    },
                                  )
                                ),
                                new Container(
                                    width: MediaQuery.of(context).size.width - 110,
                                    child: new FlatButton(
                                      child: new Text("Back",
                                        style: TextStyle(color: Color(0xFF283568), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,),
                                      onPressed: () {
                                        _quantitiesChosen = false;
                                        resetQuantities();
                                        build(context);
                                      },
                                    )
                                ),
                                SizedBox(height: 20),
                              ]
                          )
                      )
                  )
              )
          );
        }
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget _buildPopUp(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black),
      title: Text("Please order at least one item."),
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

  @override
  Widget build(BuildContext context) {
    getUser();
    if (user == null) {
      return buildWaitingScreen();
    } else {
      if (_newOrder) {
        if (_quantitiesChosen) {
          return buildOrderSummaryPage();
        }
        return buildNewOrdersPage();
      } else if (_selectedIndex == 0) {
        return buildOrdersPage();
      } else if (_selectedIndex == 1) {
        return buildHomePage();
      } else if (_selectedIndex == 2) {
        return buildProfilePage();
      }
    }
  }
}