import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/util/firestore_orders.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/state_widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class MakerScreen extends StatefulWidget {

  MakerScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MakerScreenState();

}

class _MakerScreenState extends State<MakerScreen>{

  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  final FirestoreOrders _firestoreOrders = locator<FirestoreOrders>();

  Maker user;
  List<SupplyOrder> orders;
  Map<String, List<SupplyRequest>> requests = new Map();

  bool _isLoading;
  int _selectedIndex = 1; // default loads Home Page.

  String _message = "Alert: PPE Design Update. Read More";

  bool _newPickup = false;
  bool _orderSupplies = false;

  bool _displaySettings = true;
  bool _displayMethods = false;
  List<bool> _isSelectedProfilePage = [true, false];

  List<bool> _isSelectedOrdersPage = [true, false]; // defaults at Incoming tab.
  bool _displayPending = true;
  bool _displayShipped = false;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  void _onNavigationIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _displayMethods = false;
      _displaySettings = true;
      _displayPending = true;
      _displayShipped = false;
      _newPickup = false;
      _orderSupplies = false;

      _isSelectedProfilePage[0] = _displaySettings;
      _isSelectedProfilePage[1] = _displayMethods;
      _isSelectedOrdersPage[0] = _displayPending;
      _isSelectedOrdersPage[1] = _displayShipped;
      build(context);
    });
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

  Future getUser() async {
    Maker currUser = await _firestoreUsers.getMaker(widget.userId);

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

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
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
        padding: EdgeInsets.only(top: 8.0),
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
          child: new MainAppBar(),
        ),
        body: SafeArea(
          child: new Container(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new UserTypeTag(userTag: "Maker"),
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
                        new NewPickupButton(onPressed: () {
                          _newPickup = true;
                          _selectedIndex = 0;
                          build(context);
                        }),
                        new OrderSuppliesButton(onPressed: () {
                          _orderSupplies = true;
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
        child: new MainAppBar(),
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
                            right: "Methods",
                            onPressed: (int index) {
                              setState(() {
                                _isSelectedProfilePage[index] = true;
                                _isSelectedProfilePage[1 - index] = false;
                                _displaySettings = _isSelectedProfilePage[0];
                                _displayMethods = _isSelectedProfilePage[1];
                              });
                            },
                            isSelected: _isSelectedProfilePage,
                          ),
                          if (_displayMethods) new MethodPage(user: user),
                          if (_displaySettings) new ProfileSettings(user: user, title: "Personal Information", callback: signOut)
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
        child: new MainAppBar(),
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
                        new SizedBox(height: 16,),
                        new NewPickupPlus(onPressed: () {
                          _newPickup = true;
                          _selectedIndex = 0;
                          build(context);
                        }),
                        _buildRequestList(_displayPending),
                      ],
                    )
                )
            )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex , onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildPickupPage() {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(),
      ),
      body: SafeArea(
        child: new SingleChildScrollView(
          child: new Container(
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new PickupPage(user: user),
                ]
              )
            )
          )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  Widget buildOrderSuppliesPage() {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
        child: new MainAppBar(),
      ),
      body: SafeArea(
        child: new SingleChildScrollView(
            child: new Container(
                child: Center(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new OrderSuppliesPage(user: user),
                        ]
                    )
                )
            )
        ),
      ),
      bottomNavigationBar: new MainBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: _onNavigationIconTapped),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    if (user == null || _isLoading) {
      return buildWaitingScreen();
    } else {
      getOrders();
      if (_selectedIndex == 0) {
        if (_newPickup) {
          return buildPickupPage();
        }
        if (_orderSupplies) {
          return buildOrderSuppliesPage();
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