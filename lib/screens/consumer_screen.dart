import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/util/firestore_orders.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';

import '../widgets.dart';


class ConsumerScreen extends StatefulWidget {

  ConsumerScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ConsumerScreenState();
}

class _ConsumerScreenState extends State<ConsumerScreen> {

  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  final FirestoreOrders _firestoreOrders = locator<FirestoreOrders>();
  MedicalFacility user;
  List<SupplyOrder> orders;
  Map<String, List<SupplyRequest>> requests = new Map();

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
        for (final r in order.getRequests()) {
          SupplyRequest req = await _firestoreOrders.getRequest(r);
          reqs.add(req);
        }
        setState(() {
          requests[order.supplyNo] = reqs; // initialize requests for this order
        });
      }
    }
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.8,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgcover.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        margin: const EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/default_hospital.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 5.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
    );

    return Text(
      user.getName() ?? "",
      style: _nameTextStyle,
    );
  }

  Widget _buildAddress() {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Text(
        user.getAddress() ?? "",
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildOrderDisplay(SupplyOrder order, BuildContext context) {
    if (requests != null && requests[order.supplyNo] != null) {
      return Column(
        children: <Widget>[
        for (final req in requests[order.supplyNo]) 
          new OrderDisplay(req: req)
        ],
      );
    } else {
      return new Container();
    }
  }

  Widget _buildFacilityName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        user.getFacilityName() ?? "",
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildRequestButton() {
    return RaisedButton(
      child: Text('ORDER'),
      onPressed: () => Navigator.pushNamed(context, REQUEST_SCREEN),
      padding: EdgeInsets.symmetric(horizontal: 32),
    );
  }

  Widget _buildRequestList() {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          for (final order in orders)
            Padding(child: _buildOrderDisplay(order, context),padding: EdgeInsets.symmetric(vertical: 8)),         
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

   Widget _buildAppBar() {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        title: new Text('Medical Facility Home'),
        backgroundColor: Colors.black.withOpacity(0.5),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
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

  @override
  Widget build(BuildContext context) {
    getUser();
    getOrders();
    Size screenSize = MediaQuery.of(context).size;
    if (user == null) {
      return buildWaitingScreen();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            _buildCoverImage(screenSize),
            SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.height / 4.7,
                    ),
                    _buildProfileImage(),
                    _buildFullName(),
                    _buildFacilityName(),
                    _buildAddress(),
                    _buildRequestButton(),
                    Container(
                      margin: EdgeInsets.only(left: 32),
                      alignment: Alignment.centerLeft,
                      child:  new Text('ORDER HISTORY',
                        style: new TextStyle(fontSize: 14.0, color: Colors.grey)),
                    ),
                    orders == null ? 
                      buildWaitingScreen()
                    : orders.length == 0 ? 
                    Container(
                      alignment: Alignment.center,
                      child:  new Text('No orders yet',
                        style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                    )
                    :
                    Container(
                        height: screenSize.height / 3.5, 
                        child: _buildRequestList(),
                      )
                  ],
                ),
              ),
              _buildAppBar()
            ],
          ),
      );
    }
  }
}