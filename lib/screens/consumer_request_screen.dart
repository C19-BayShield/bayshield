import 'package:flutter/material.dart';
import 'package:supplyside/screens/quantity_screen.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/util/mock_consts.dart';

Map<String, Item> itemRequestMap = {
  'Aersol Box': aerosolBox,
  'Body Suit': bodySuit,
  'Face Shield': faceShield,
  'Gloves': gloves,
  'Goggles': goggles,
  'N95 Regular': n95Regular,
  'N95 Small': n95Small,
  'Sanitizer': sanitizer,
  'Surgical Mask': surgicalMask,
  'Wipes': wipes
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

  List<bool> aerosolBoxSelected = [false];
  List<bool> bodySuitSelected = [false];
  List<bool> faceShieldSelected = [false];
  List<bool> glovesSelected = [false];
  List<bool> gogglesSelected = [false];
  List<bool> n95RegularSelected = [false];
  List<bool> n95SmallSelected = [false];
  List<bool> sanitizerSelected = [false];
  List<bool> surgicalMaskSelected = [false];
  List<bool> wipesSelected = [false];


  Widget  _buildGenericDropDown({List<String> options, String value, Function(String) onChange, String hintText="Select Option"}) {
    return DropdownButton<String>(
              value: value,
              icon: Icon(Icons.arrow_downward),
              hint: Text(hintText),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: Color(0xFFE6B819)
              ),
              underline: Container(
                height: 2,
                color: Color(0xFFD58032),
              ),
              onChanged: onChange,
              items: 
                options.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                })
                .toList(),
            );
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
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Request Parts Form', style: Theme.of(context).textTheme.headline2,),
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
                            style: TextStyle(fontSize: 18.0, color: Color(0xFFE6B819),),)
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Aerosol Box', style: Theme.of(context).textTheme.headline5,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: ToggleButtons(
                                  children: <Widget>[
                                    Container(
                                      width: 140.0,
                                      height: 140.0,
                                      color: Colors.white,
                                      child: Image.asset('assets/images/aerosol_box.png'),
                                    ),
                                  ],
                                  selectedBorderColor: Color(0xFFE6B819),
                                  borderColor: Color(0xFF313F84),
                                  borderWidth: 8.0,
                                  onPressed: (int index) {
                                    setState(() {
                                      aerosolBoxSelected[index] = !aerosolBoxSelected[index];
                                    });
                                  },
                                  isSelected: aerosolBoxSelected,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Body Suit', style: Theme.of(context).textTheme.headline5,),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: ToggleButtons(
                                  children: <Widget>[
                                    Container(
                                      width: 140.0,
                                      height: 140.0,
                                      color: Colors.white,
                                      child: Image.asset('assets/images/body_suit.jpg'),
                                    ),
                                  ],
                                  selectedBorderColor: Color(0xFFE6B819),
                                  borderColor: Color(0xFF313F84),
                                  borderWidth: 8.0,
                                  onPressed: (int index) {
                                    setState(() {
                                      bodySuitSelected[index] = !bodySuitSelected[index];
                                    });
                                  },
                                  isSelected: bodySuitSelected,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Face Shield', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/face_shield.jpeg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        faceShieldSelected[index] = !faceShieldSelected[index];
                                      });
                                    },
                                    isSelected: faceShieldSelected,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Gloves', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/gloves.jpg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        glovesSelected[index] = !glovesSelected[index];
                                      });
                                    },
                                    isSelected: glovesSelected,
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Goggles', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/goggles.jpeg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        gogglesSelected[index] = !gogglesSelected[index];
                                      });
                                    },
                                    isSelected: gogglesSelected,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('N95 Regular', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/n95_regular.jpg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        n95RegularSelected[index] = !n95RegularSelected[index];
                                      });
                                    },
                                    isSelected: n95RegularSelected,
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('N95 Small', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/n95_small.jpeg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        n95SmallSelected[index] = !n95SmallSelected[index];
                                      });
                                    },
                                    isSelected: n95SmallSelected,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Sanitizer', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/hand_sanitizer.jpeg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        sanitizerSelected[index] = !sanitizerSelected[index];
                                      });
                                    },
                                    isSelected: sanitizerSelected,
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Surgical Mask', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/surgical_mask.png'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        surgicalMaskSelected[index] = !surgicalMaskSelected[index];
                                      });
                                    },
                                    isSelected: surgicalMaskSelected,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Wipes', style: Theme.of(context).textTheme.headline5,),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Container(
                                        width: 140.0,
                                        height: 140.0,
                                        color: Colors.white,
                                        child: Image.asset('assets/images/wipes.jpg'),
                                      ),
                                    ],
                                    selectedBorderColor: Color(0xFFE6B819),
                                    borderColor: Color(0xFF313F84),
                                    borderWidth: 8.0,
                                    onPressed: (int index) {
                                      setState(() {
                                        wipesSelected[index] = !wipesSelected[index];
                                      });
                                    },
                                    isSelected: wipesSelected,
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),

                      RaisedButton(child: Text('Next'), onPressed: () {
                        Map<String, bool> selected = new Map();
                        selected["Aerosol Box"] = aerosolBoxSelected[0];
                        selected["Body Suit"] = bodySuitSelected[0];
                        selected["Face Shield"] = faceShieldSelected[0];
                        selected["Gloves"] = glovesSelected[0];
                        selected["Goggles"] = gogglesSelected[0];
                        selected["N95 Regular"] = n95RegularSelected[0];
                        selected["N95 Small"] = n95SmallSelected[0];
                        selected["Sanitizer"] = sanitizerSelected[0];
                        selected["Surgical Mask"] = surgicalMaskSelected[0];
                        selected["Wipes"] = wipesSelected[0];

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              QuantityScreen(key: widget.key, selected: selected)),
                        );
                      }
                      )
                    ],
                  ),
                ])
              )]
            )
          ),
        )   
      );
  }
}
