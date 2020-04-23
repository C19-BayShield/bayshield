import 'package:flutter/material.dart';
import 'package:supplyside/screens/quantity_screen.dart';
import 'package:supplyside/util/item_consts.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/widgets.dart';

class OrderRequestPage extends StatefulWidget {
  OrderRequestPage({Key key}) : super(key: key);

  @override
  _OrderRequestPageState createState() => _OrderRequestPageState();
}

class _OrderRequestPageState extends State<OrderRequestPage> {

  final List<Item> items = itemsToRequest;
  List<List<bool>> selectedItems = [for (var i = 0; i < itemsToRequest.length; i++) [false]];
  bool _chosen = false;

  Widget _buildRow(int start) {
      return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = start; i < start + 2; i++) 
          new ItemDisplay(
          item: items[i], 
          onPressed: (int index) {
            setState(() {
              selectedItems[i][index] =
              !selectedItems[i][index];
            });
          },
          isSelected: selectedItems[i],
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Center(
                child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('Request Parts Form', style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline2,),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Select Item(s)',
                                      style: TextStyle(fontSize: 18.0,
                                        color: Color(0xFFE6B819),),)
                                  ],
                                ),
                                for (var i = 0; i < items.length; i+=2)  _buildRow(i),
                                RaisedButton(
                                    child: Text('Next'), onPressed: () {
                                  Map<String, bool> selected = new Map();
                                  selected["Aerosol Box"] =
                                  selectedItems[0][0];
                                  selected["Body Suit"] = selectedItems[1][0];
                                  selected["Face Shield"] =
                                  selectedItems[2][0];
                                  selected["Gloves"] = selectedItems[3][0];
                                  selected["Goggles"] = selectedItems[4][0];
                                  selected["N95 Regular"] =
                                  selectedItems[5][0];
                                  selected["N95 Small"] = selectedItems[6][0];
                                  selected["Sanitizer"] = selectedItems[7][0];
                                  selected["Surgical Mask"] =
                                 selectedItems[8][0];
                                  selected["Wipes"] = selectedItems[9][0];

                                  _chosen = false;

                                  selected.forEach((k, v) =>
                                  {
                                    if (selected[k] == true) _chosen = true
                                  });

                                  if (_chosen) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          QuantityScreen(key: widget.key,
                                              selected: selected)),
                                    );
                                  }
                                  {
                                    showSnackBar(context);
                                  }
                                }
                                )
                              ],
                            ),
                          ])
                      )
                    ]
                )
            ),
          );
        }
      )
    );
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Must choose at least one item.'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
