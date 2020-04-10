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
  String q1Ans;
  String q2Ans;
  String q3Ans;
  String q4Ans;
  final List<String> ppeQChoices = ["All of staff","75% of staff", "50% of staff", "25% of staff", "Less than 25% of staff"];
  final List<String> hasCasesQChoices = ["Yes, Less than 100","Yes, 100-500","Yes, Greater than 500","No"];
  final List<String> urgQChoices = ["As Soon As Possible", "Very Urgently", "Extremely Urgently"];
  final List<String> sizeQChoices = ["Less than 500","500-1,000","1,000-5,000", "5,000-10,000", "10,0000+"];


  _buildItemDropDown() {
  return DropdownButton<String>(
            value: itemRequested.name,
            icon: Icon(Icons.arrow_downward),
            hint: Text('Select Item'),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Color(0xFFE6B819)
            ),
            underline: Container(
              height: 2,
              color: Color(0xFFD58032),
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
                      ],),
                      Text('How much of your staff currently has protective equipment?'),
                      this._buildGenericDropDown(
                        options:ppeQChoices, 
                        onChange:(String newValue) => setState((){q1Ans = newValue;}),
                        value: q1Ans,
                        ),
                      Text('Does your facility have any reported Covid-19 cases, if so how many?'),
                      this._buildGenericDropDown(
                        options:hasCasesQChoices, 
                        onChange:(String newValue) => setState((){q2Ans = newValue;}),
                        value: q2Ans,
                        ),
                      Text('How soon do you require your protective equipment?'),
                      this._buildGenericDropDown(
                        options:urgQChoices, 
                        onChange:(String newValue) => setState((){q3Ans = newValue;}),
                        value: q3Ans,
                        ),
                      Text('How many patients off all types(Covid & non-Covid related) does your facility process each day?'),
                      this._buildGenericDropDown(
                        options:sizeQChoices, 
                        onChange:(String newValue) => setState((){q4Ans = newValue;}),
                        value: q4Ans,
                        ),
                      
                      RaisedButton(child: Text('Submit Request'), onPressed: () => null,)
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
