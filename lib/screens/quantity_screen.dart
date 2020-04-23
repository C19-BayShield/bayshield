import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/screens/info_question_screen.dart';
import 'package:supplyside/screens/consumer_request_screen.dart';

class QuantityScreen extends StatefulWidget {
  QuantityScreen({this.key, this.selected});

  final Key key;
  final Map<String, bool> selected;

  @override
  State<StatefulWidget> createState() => new _QuantityScreenState();

}

class _QuantityScreenState extends State<QuantityScreen>{

//  int aerosolBoxQuantity = 0;
//  int bodySuitQuantity = 0;
//  int faceShieldQuantity = 0;
//  int gloveQuantity = 0;
//  int goggleQuantity = 0;
//  int n95RegularQuantity = 0;
//  int n95SmallQuantity = 0;
//  int sanitizerQuantity = 0;
//  int surgicalMaskQuantity = 0;
//  int wipeQuantity = 0;
  bool _zeroQuantity = true;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Builder(
          builder: (BuildContext context )
    {
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
                                Text('Input quantities for item(s)',
                                  style: TextStyle(
                                    fontSize: 18.0, color: Color(0xFFE6B819),),)
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Aerosol Box"] ==
                                      true) _createForm("Aerosol Box"),
                                  if (widget.selected["Aerosol Box"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Body Suit"] ==
                                      true) _createForm("Body Suit"),
                                  if (widget.selected["Body Suit"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Face Shield"] ==
                                      true) _createForm("Face Shield"),
                                  if (widget.selected["Face Shield"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Gloves"] ==
                                      true) _createForm("Gloves"),
                                  if (widget.selected["Gloves"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Goggles"] ==
                                      true) _createForm("Goggles"),
                                  if (widget.selected["Goggles"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["N95 Regular"] ==
                                      true) _createForm("N95 Regular"),
                                  if (widget.selected["N95 Regular"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["N95 Small"] ==
                                      true) _createForm("N95 Small"),
                                  if (widget.selected["N95 Small"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Sanitizer"] ==
                                      true) _createForm("Sanitizer"),
                                  if (widget.selected["Sanitizer"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Surgical Mask"] ==
                                      true) _createForm("Surgical Mask"),
                                  if (widget.selected["Surgical Mask"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Wipes"] ==
                                      true) _createForm("Wipes"),
                                  if (widget.selected["Wipes"] ==
                                      true) _quantityForm(),
                                ]
                            ),
                            RaisedButton(child: Text('Next'), onPressed: () {
                              if (_zeroQuantity) {
                                showSnackBar(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      InfoQuestionScreen(key: widget.key,
                                          selected: widget.selected)),
                                );
                              }
                            }
                            ),
                            RaisedButton(child: Text('Back'),
                                color: Color(0xFF313F84),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        OrderRequestPage(key: widget.key)),
                                  );
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
      content: Text('Quantity cannot be zero.'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  IntrinsicWidth _quantityForm() {
    double c_width = MediaQuery.of(context).size.width;
    return IntrinsicWidth(
      child: Container(
        width: c_width * .5,
        height: 100,
        child: TextField(
          textAlign: TextAlign.center,
          scrollPadding: EdgeInsets.symmetric(horizontal: 16),
          maxLines: 1,
          autofocus: false,
          maxLength: 4,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
            labelText: "Amount Requested",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (value){
            _zeroQuantity = value == "0";
            setState(() {});
          }, // Only numbers can be entered
        ),
      ),
    );
  }

  Column _createForm(String tag) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(tag, style: Theme.of(context).textTheme.headline5,),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: 140.0,
              height: 140.0,
              color: Colors.white,
              child: _chooseImage(tag)
          ),
        ),
      ],
    );
  }

  Image _chooseImage(String tag) {
    if (tag == "Aerosol Box") {
      return Image.asset('assets/images/aerosol_box.png');
    } else if (tag == "Body Suit") {
      return Image.asset('assets/images/body_suit.jpg');
    } else if (tag == "Face Shield") {
      return Image.asset('assets/images/face_shield.jpeg');
    } else if (tag == "Gloves") {
      return Image.asset('assets/images/gloves.jpg');
    } else if (tag == "Goggles") {
      return Image.asset('assets/images/goggles.jpeg');
    } else if (tag == "N95 Regular") {
      return Image.asset('assets/images/n95_regular.jpg');
    } else if (tag == "N95 Small") {
      return Image.asset('assets/images/n95_small.jpeg');
    } else if (tag == "Sanitizer") {
      return Image.asset('assets/images/hand_sanitizer.jpeg');
    } else if (tag == "Surgical Mask") {
      return Image.asset('assets/images/surgical_mask.png');
    } else if (tag == "Wipes") {
      return Image.asset('assets/images/wipes.jpg');
    }

  }
}