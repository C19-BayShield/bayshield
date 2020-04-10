import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/util/mock_consts.dart';

Map<String, Item> itemRequestMap = {
  'Face Shield': faceShield,
  'Aersol Box': aerosolBox
};

class OrderRequestPage extends StatefulWidget {
  OrderRequestPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _OrderRequestPageState createState() => _OrderRequestPageState();
}

class _OrderRequestPageState extends State<OrderRequestPage> {
  int _counter = 0;
  Item itemRequested = faceShield;

  _buildItemDropDown() {

  return DropdownButton<String>(
            value: itemRequested.name,
            icon: Icon(Icons.arrow_downward),
            hint: Text('Select Item'),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.deepPurple
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                itemRequested = itemRequestMap[newValue];
              });
            },
            items: 
              itemsToRequest.map<DropdownMenuItem<String>>((Item option) {
                return DropdownMenuItem<String>(
                  value: option.name,
                  child: Text(option.name),
                );
              })
              .toList(),
          );
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text('Select Requested Item'), SizedBox(width: 16,), _buildItemDropDown()],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IntrinsicWidth(
                      child:       
                        Container(
                          width: c_width * .5,
                          height: 100,
                          child: TextField(
                            textAlign: TextAlign.center,
                            scrollPadding: EdgeInsets.symmetric(horizontal: 16),
                            maxLines: 1,
                            autofocus: false,
                            maxLength: 4,
                            maxLengthEnforced: true,
                            decoration: new InputDecoration(labelText: "Amount Requested"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                          ),
                        ),
                    )
                ],)
              ],
            ),
          ),
      )   
      );
  }
}
