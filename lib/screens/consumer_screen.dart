import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:supplyside/datamodels/order.dart';
import 'package:supplyside/util/consts.dart';
import 'package:supplyside/util/mock_consts.dart';


class ConsumerScreen extends StatelessWidget {

  ConsumerScreen({Key key}) : super(key: key);

  _buildRequestItem(SupplyRequest req, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget> [
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network('http://via.placeholder.com/64', 
                  width: 64, 
                  height: 64,
                  fit: BoxFit.fill
                ),
              ),
              Column(
                children: <Widget>[
                  Row(children: <Widget>[Text(req.item.name, style: Theme.of(context).textTheme.headline3,), SizedBox(width: 16),],),
                  Text('${req.amtOrdered.toString()} Ordered', style: Theme.of(context).textTheme.subtitle2 ),
                  Text('${req.statusToString()}', style: Theme.of(context).textTheme.subtitle2)
                ],
              )
            ],
        ),
        Container(
          color: Color(0xFFF6F6F7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Order #DOJF837D', style: Theme.of(context).textTheme.subtitle2),
                Text('Order Date - 06 May 2020', style: Theme.of(context).textTheme.subtitle2)
              ],
            )
          ),
        )
        ]
      )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    
                    Text('Yo hope this dont repeat')
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