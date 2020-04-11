import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/mock_consts.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:firebase_database/firebase_database.dart';


class ConsumerScreen extends StatefulWidget {

  ConsumerScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ConsumerScreenState();
}

class _ConsumerScreenState extends State<ConsumerScreen> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  TextStyle orderStyle = TextStyle(fontSize: 16.0,letterSpacing: .5, color: Color(0xFF263151));
  TextStyle orderSubtitleStyle = TextStyle(fontSize: 14.0,letterSpacing: .5, color: Color(0xFFA5A9B4));


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
    return Scaffold(
      appBar: new AppBar(
          title: new Text('Medical Facility Home'),
          backgroundColor: Color(0xFF313F84),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: LiquidPullToRefresh(
            onRefresh: () => null,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Center(child: Icon(Icons.arrow_upward)),
                    Center(child: Text('Pull down to refresh')),
                    RaisedButton(
                      child: Text('New Request'),
                      onPressed: () => Navigator.pushNamed(context, REQUEST_SCREEN),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    for(final req in TEST_REQS)
                      Padding(child: _buildRequestItem(req, context),padding: EdgeInsets.symmetric(vertical: 8)),                    
                  ]),
                )
                
              ],
            )
          )
        )
      ),
    );
  }
}