import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/state_widgets.dart';
import 'package:supplyside/util/firestore_orders.dart';
import 'package:supplyside/util/item_consts.dart';


class MedicalOrganizationScreen extends StatefulWidget {

  MedicalOrganizationScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MedicalOrganizationScreenState();
}

class _MedicalOrganizationScreenState extends State<MedicalOrganizationScreen> {

  // firestore dependent variables
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  final FirestoreOrders _firestoreOrders = locator<FirestoreOrders>();
  MedicalFacility user;
  List<SupplyOrder> orders;
  Map<String, List<SupplyRequest>> requests = new Map();
  bool _isLoading;

  int _selectedIndex = 1; // default loads Home Page.

  TextStyle orderStyle = TextStyle(fontSize: 16.0,letterSpacing: .5, color: Color(0xFF263151));
  TextStyle orderSubtitleStyle = TextStyle(fontSize: 14.0,letterSpacing: .5, color: Color(0xFFA5A9B4));
  String _message = "Alert: PPE Design Update. Read More";

  bool _newOrder = false;
  bool _quantitiesChosen = false;

  bool _displaySettings = true;
  bool _displayStatus = false;
  List<bool> _isSelectedProfilePage = [true, false];

  List<bool> _isSelectedOrdersPage = [true, false]; // defaults at Incoming tab.
  bool _displayPending = true;
  bool _displayShipped = false;

  // Order quantities
  int faceShieldCount = 0;
  int n95Count = 0;
  int glovesCount = 0;
  int gogglesCount = 0;
  int gownCount = 0;
  int sanitizerCount = 0;

  @override 
  void initState() {
    _isLoading = false;
    super.initState();
  }


  void _onNavigationIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _displayStatus = false;
      _displaySettings = true;
      _displayPending = true;
      _displayShipped = false;
      _newOrder = false;
      _quantitiesChosen = false;

      resetQuantities();

      _isSelectedProfilePage[0] = _displaySettings;
      _isSelectedProfilePage[1] = _displayStatus;
      _isSelectedOrdersPage[0] = _displayPending;
      _isSelectedOrdersPage[1] = _displayShipped;
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

/* Async functions fetching from DB BEGIN */

  Future getUser() async {
    MedicalFacility currUser = await _firestoreUsers.getMedicalFacility(widget.userId);
    if (currUser != null) {
      if (!mounted) return;
      setState(() {
        user = currUser;
      });
    }
  }

  Future getOrders() async {
    List<SupplyOrder> temp = await _firestoreOrders.getOrders(widget.userId);
    if (temp != null) {
      if (!mounted) return;

      setState(() {
        orders = temp; // initialize orders
      });

      // parse requests for each order
      for (final order in temp) {
        List<SupplyRequest> reqs = [];
        List<String> ordersReqs = order.getRequests();
        if (ordersReqs.length > 0) {
          for (String r in ordersReqs) {
            SupplyRequest req = await _firestoreOrders.getRequest(r);
            reqs.add(req);
          }
          setState(() {
          requests[order.supplyNo] = reqs; // initialize requests for this order
        });
        } 
      }
    }
  }

  // creating orders and requests
  void validateAndSubmit() async {
    if (validateAndSave()) {
      List<String> requestIDs = [];
      try {
        // create individual requests 
        List<int> counts = [faceShieldCount, n95Count, glovesCount, 
        gogglesCount, gownCount, sanitizerCount];
        List<Item> items = [faceShield, n95Regular, gloves, goggles, gown, sanitizer];
        for (int i = 0; i < counts.length; i++) {
          if (counts[i] > 0) {
            String reqID = await _firestoreOrders.createRequest
            (SupplyRequest(amtOrdered: counts[i] , item: items[i], status: Status.pending));
            requestIDs.add(reqID);
          }
        }

        // now that we have IDs for requests, create the overarching order
        SupplyOrder currOrder = new SupplyOrder(userId: widget.userId, 
        requests: requestIDs, status: Status.pending);
        await _firestoreOrders.createOrder(currOrder);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void deleteRequest(SupplyOrder order, SupplyRequest req) async {
    // first delete reference in order datamodel
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestoreOrders.deleteRequest(order, req.requestNo);
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  /* Async functions END */


  /* Order display functions BEGIN */

  Widget _buildOrderDisplay(SupplyOrder order, BuildContext context) {
    if (requests != null && requests[order.supplyNo] != null) {
      return Column(
        children: <Widget>[
        for (final req in requests[order.supplyNo]) 
          new RequestCard(req: req, order: order, onDelete: _buildDeleteConfirmation,)
        ],
      );
    } else {
      return new Container();
    }
  }

   Widget _buildRequestList(bool pending) {
    return new Container (
      padding: EdgeInsets.only(top: 16.0),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            for (final order in orders) 
               (pending && order.status != Status.shipped) ?
                Padding(child: _buildOrderDisplay(order, context),padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32.0))    
                : (!pending && order.status == Status.shipped) ? 
                Padding(child: _buildOrderDisplay(order, context),padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32.0))
                : new Container()
          ], 
        )
      );
  }

  int getTotalPendingRequests() {
    int total = 0;
    if (orders != null) {
      for (final order in orders) {
        if (order.status != Status.shipped && requests[order.supplyNo] != null) {
          total += requests[order.supplyNo].length;
        }
      }
    }
    return total;
  } 

  int getTotalShippedRequests() {
    int total = 0;
    if (orders != null) {
      for (final order in orders) {
        if (order.status == Status.shipped && requests[order.supplyNo] != null) {
          total += requests[order.supplyNo].length;
        }
      }
    }
    return total;
  } 

  /* Order display functions END */ 

  Widget _buildDeleteConfirmation(BuildContext context, SupplyOrder order, SupplyRequest req) {
    return new AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black),
      title: Text('Are you sure you want to delete the order of ' + req.amtOrdered.toString() + " " + req.item.name + " from your pending orders? You cannot undo this action."),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            deleteRequest(order, req);
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
    _onNavigationIconTapped(0);
  }

  void _onShippedPressed() {
    _onNavigationIconTapped(0);
    setState(() {
      _displayShipped = true;
      _displayPending = false;
      _isSelectedOrdersPage[0] = _displayPending;
      _isSelectedOrdersPage[1] = _displayShipped;
    });
  }

  bool validateAndSave() {
    bool nonNeg = faceShieldCount >= 0 && n95Count >= 0 &&
    glovesCount >= 0 && gogglesCount >= 0 &&  gownCount >= 0 && 
    sanitizerCount >= 0;
    bool oneNonZero =  faceShieldCount > 0 || n95Count > 0 ||
    glovesCount > 0 || gogglesCount > 0 ||  gownCount > 0 || 
    sanitizerCount > 0;
    return nonNeg && oneNonZero;
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
                                      child: new PendingItemsCard(pending: getTotalPendingRequests(), onPressed: _onPendingPressed),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 7,
                                      width: (MediaQuery.of(context).size.width - 120) / 2,
                                      color: Colors.transparent,
                                      child: new ShippedItemsCard(shipped: getTotalShippedRequests(), onPressed: _onShippedPressed),
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
                    TwoToggle(
                      left: "Pending",
                      right: "Shipped",
                      onPressed: (int index) {
                        setState(() {
                          _isSelectedOrdersPage[index] = true;
                          _isSelectedOrdersPage[1 - index] = false;
                          _displayPending = _isSelectedOrdersPage[0];
                          _displayShipped= _isSelectedOrdersPage[1];
                        });
                      },
                      isSelected: _isSelectedOrdersPage,
                    ),
                    _buildRequestList(_displayPending),
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
                                      validateAndSubmit();
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
    if (user == null || _isLoading) {
      return buildWaitingScreen();
    } else {
      getOrders();
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