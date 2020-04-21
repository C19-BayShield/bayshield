import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/mock_consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';


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

  TextStyle orderStyle = TextStyle(fontSize: 16.0,letterSpacing: .5, color: Color(0xFF263151));
  TextStyle orderSubtitleStyle = TextStyle(fontSize: 14.0,letterSpacing: .5, color: Color(0xFFA5A9B4));

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
      user.getName(),
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
        user.getAddress(),
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

  Widget _buildFacilityName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        user.getFacilityName(),
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
                      height: screenSize.height / 3.3, 
                      child: _buildRequestList(),
                    ),
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