import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/mock_consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';


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
  int _shipped = 100;
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

      nameController.clear();
      emailController.clear();
      phoneNumberController.clear();
      addressController.clear();

      _isSelectedProfilePage[0] = _displayInventory;
      _isSelectedProfilePage[1] = _displaySettings;
      build(context);
    });
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

  Widget _buildRequestItem(SupplyRequest req, BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
        Container(
          width: c_width * .8,
          color: Color(0xFF313F84),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(req.item.imageUrl, 
                    width: 64, 
                    height: 64,
                    fit: BoxFit.fill
                  ),
                ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(mainAxisSize: MainAxisSize.min,children: <Widget>[Text(req.item.name, style: Theme.of(context).textTheme.headline3,), SizedBox(width: 16),],),
                    Text('${req.amtOrdered.toString()} Ordered', style: Theme.of(context).textTheme.subtitle2 ),
                    Text('${req.statusToString()}', style: Theme.of(context).textTheme.subtitle2)
                  ],
                )
              ],
            ),
          ),
        Container(
          color: Color(0xFFFFFFFF),
          width: c_width * .8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Order #DOJF837D', style: this.orderStyle,),
                Text('Order Date - 06 May 2020', style: this.orderSubtitleStyle)
              ],
            )
          ),
        )
        ]
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
                                      child: new PendingItemsCard(pending: _pending, onPressed: () => {}),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 7,
                                      width: (MediaQuery.of(context).size.width - 120) / 2,
                                      color: Colors.transparent,
                                      child: new ShippedItemsCard(shipped: _shipped, onPressed: () => {}),
                                    ),
                                  ]
                              )
                          ),
                          new NewOrderButton(onPressed: () => Navigator.pushNamed(context, REQUEST_SCREEN),),
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

  @override
  Widget build(BuildContext context) {
    getUser();
    if (user == null) {
      return buildWaitingScreen();
    } else {
      return buildHomePage();
      // if (_selectedIndex == 0) {
      //   if (_addButtonPressed) {
      //     return buildConfirmationPage();
      //   } else if (_arrowPressed) {
      //     return buildShippingPage();
      //   }
      //   return buildOrdersPage();
      // } else if (_selectedIndex == 1) {
      //   return buildHomePage();
      // } else if (_selectedIndex == 2) {
      //   return buildProfilePage();
      // }
    }
  }
}